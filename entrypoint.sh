#!/usr/bin/env bash
set -e

chown --recursive sftp /media/sftp

echo "The sftp share can be mounted with sshfs (\"sshfs -o IdentityFile=IDENTITY sftp@IP_ADDRESS:/media/sftp /media/TARGET\")"
echo "Authorized public keys:"
echo "$AUTHORIZED_PUBLIC_KEYS"
mkdir --parents /app/sftp
echo "$AUTHORIZED_PUBLIC_KEYS" > /app/sftp/authorized_keys

if [[ -z "$HOST_KEY" ]]; then
    echo "Host key or host public key not specified."
    public-key-infrastructure.sh --create ssh-key
    rm ssh-key.pub
    mv ssh-key /app/sftp/host_key
else
    echo "$HOST_KEY" > /app/sftp/host_key
    chmod 0600 /app/sftp/host_key
fi

exec "$@"
