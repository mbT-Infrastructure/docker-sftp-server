FROM madebytimo/base

RUN apt update && apt install -y ssh && rm -rf /var/lib/apt/lists/*
RUN mkdir -p --mode 0755 /var/run/sshd

RUN adduser sftp --disabled-password --gecos "" --home /media/sftp
COPY sshd_config /etc/ssh/

RUN mkdir --parents /media/sftp

ENV PUBLIC_KEYS=""

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/sbin/sshd", "-D" ]
