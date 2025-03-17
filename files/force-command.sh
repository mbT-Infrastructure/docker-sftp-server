#!/usr/bin/env bash
set -e -o pipefail

read -a COMMAND -r <<<"$SSH_ORIGINAL_COMMAND"

if [[ "${SSH_ORIGINAL_COMMAND}" == "internal-sftp" ]]; then
    exec /usr/lib/openssh/sftp-server -d /data
elif [[ "${COMMAND[0]}" == "rsync" ]] && [[ "${COMMAND[1]}" == --server ]]; then
    exec "${COMMAND[@]}"
else
    echo "Command not allowed: ${COMMAND[*]}"
    exit 1
fi
