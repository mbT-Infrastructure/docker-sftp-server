#!/usr/bin/env bash
set -e -o pipefail

mkdir --parents /media/ssh

chown sftp /media/sftp/data
if [[ -n "$FILE_PERMISSIONS" ]]; then
    echo "Set file permissions to \"${FILE_PERMISSIONS}\"."
    chmod --recursive "$FILE_PERMISSIONS" /media/sftp/data
fi

echo "The sftp share can be mounted with sshfs" \
    "(\"sshfs sftp@###HOST###:/data /media/###TARGET###\")"
if [[ -n "$AUTHORIZED_PUBLIC_KEYS" ]]; then
    echo "$AUTHORIZED_PUBLIC_KEYS" > /media/ssh/authorized_keys
    ls -la /media/ssh/authorized_keys
    chmod 0644 /media/ssh/authorized_keys
elif [[ -f /media/ssh/authorized_keys ]]; then
    echo "Using existing authorized public keys from /media/ssh/authorized_keys."
else
    echo "No authorized public keys specified."
fi
echo "Authorized public keys:"
cat /media/ssh/authorized_keys

if [[ -n "$HOST_KEY" ]]; then
    echo "$HOST_KEY" > /media/ssh/host_key
    chmod 0600 /media/ssh/host_key
elif [[ -f /media/ssh/host_key ]]; then
    echo "Using existing host key from /media/ssh/host_key."
else
    echo "Host key or host not specified. Create one."
    public-key-infrastructure.sh --create ssh-key
    rm ssh-key.pub
    mv ssh-key /media/ssh/host_key
fi

exec "$@"
