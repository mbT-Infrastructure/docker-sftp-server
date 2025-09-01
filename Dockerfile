FROM madebytimo/base AS builder

RUN install-autonomous.sh install SSHServer \
    && apt update -qq && apt install -y -qq python3 rsync \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/builder/chroot

RUN for COMMAND in "$SHELL" "$(which env)" "$(which ls)" "$(which rsync)" \
            /usr/lib/openssh/sftp-server; do \
        cp --parents  "$COMMAND" . \
        && ldd "$COMMAND" \
            | sed --silent 's|^[^/]*\(/\S*\)\s.*$|\1|p' \
            | while read -r LIBRARY; do \
                cp --parents "$LIBRARY" .; \
        done \
    done

FROM madebytimo/base

RUN install-autonomous.sh install ScriptsAdvanced SSHServer \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/ssh/* \
    && mkdir -p --mode 0755 /var/run/sshd \
    \
    && mkdir --parents /media/sftp/{data,dev,etc} /media/ssh \
    && usermod --login sftp --home /media/sftp/data user \
    && usermod --password '*' sftp \
    \
    && mknod -m 666 /media/sftp/dev/null c 1 3 \
    && mknod -m 666 /media/sftp/dev/zero c 1 5 \
    && chown root:root /media/sftp/dev/{null,zero} \
    && grep '^sftp:' /etc/passwd >> /media/sftp/etc/passwd

COPY files/sshd_config /etc/ssh/
COPY --from=builder /root/builder/chroot /media/sftp
COPY files/force-command.sh /media/sftp/usr/local/bin/

ENV AUTHORIZED_PUBLIC_KEYS=""
ENV FILE_PERMISSIONS=""
ENV HOST_KEY=""

COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "/usr/sbin/sshd", "-D", "-e" ]

LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/mbt-infrastructure/docker-sftp-server"
