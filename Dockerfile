FROM madebytimo/base

RUN install-autonomous.sh install ScriptsAdvanced && \
    apt update -qq && apt install -y -qq ssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/ssh/*
RUN mkdir -p --mode 0755 /var/run/sshd

RUN adduser sftp --disabled-password --gecos "" --home /media/sftp
COPY sshd_config /etc/ssh/

RUN mkdir --parents /media/sftp

ENV AUTHORIZED_PUBLIC_KEYS=""
ENV HOST_KEY=""

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/sbin/sshd", "-D" ]
# CMD ls -la /etc/ssh
