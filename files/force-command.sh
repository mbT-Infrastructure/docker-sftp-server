#!/usr/bin/env bash
set -e -o pipefail

read -a COMMAND -r <<<"$SSH_ORIGINAL_COMMAND"

cd /data

if [[ "${COMMAND[0]}" == "command" ]]; then
    COMMAND=("${COMMAND[@]:1}")
fi

if [[ "${SSH_ORIGINAL_COMMAND}" == "internal-sftp" ]]; then
    exec /usr/lib/openssh/sftp-server -d "$PWD"
elif [[ "${COMMAND[0]}" == "ls" ]]; then
    if [[ "${COMMAND[-1]}" == *"*" ]]; then
        COMMAND=( "${COMMAND[@]::${#COMMAND[@]}-1}" "${COMMAND[-1]%%\*}"* )
    fi
    exec "${COMMAND[@]}"
elif [[ "${COMMAND[0]}" == "pwd" ]]; then
    builtin pwd
elif [[ "${COMMAND[0]}" == "rsync" ]] && [[ "${COMMAND[1]}" == --server ]]; then
    exec "${COMMAND[@]}"
else
    echo "Command not allowed: \"${COMMAND[*]}\"" >&2
    exit 1
fi
