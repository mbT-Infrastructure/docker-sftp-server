#!/usr/bin/env bash
set -e

echo "The sftp share can be mounted with sshfs (\"sshfs -o IdentityFile=IDENTITY sftp@IP_ADDRESS:/media/sftp /media/TARGET\")"
echo "Authorized keys:"
echo "$PUBLIC_KEYS"
mkdir --parents /app/sftp
echo "$PUBLIC_KEYS" > /app/sftp/authorized_keys

chown --recursive sftp /media/sftp

exec "$@"
