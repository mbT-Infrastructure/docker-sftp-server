FROM madebytimo/base

RUN install-autonomous.sh install ScriptsAdvanced \
    && apt update -qq && apt install -y -qq ssh \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/ssh/* \
    && mkdir -p --mode 0755 /var/run/sshd

RUN mkdir --parents /media/sftp/data /media/ssh \
    && usermod --login sftp --home /media/sftp/data user \
    && usermod --password '*' sftp

COPY files/sshd_config /etc/ssh/


ENV AUTHORIZED_PUBLIC_KEYS=""
ENV FILE_PERMISSIONS=""
ENV HOST_KEY=""

COPY files/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/sbin/sshd", "-D", "-e" ]
