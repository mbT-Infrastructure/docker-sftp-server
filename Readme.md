# sftp-server image

This image starts a ssh server which only allows sftp connections. The authentication is key-based
only.

## Installation

1. Pull from [Docker Hub], download the package from [Releases] or build using `builder/build.sh`

## Usage

This Container image extends the [base image]. Make sure to also configure environment variables,
ports and volumes from that image.

## Environment variables

-   `AUTHORIZED_PUBLIC_KEYS`
    -   Public keys with access to the ssh server. For example
        `ssh-rsa AAAAB3Nz... user@example.madebytimo.de`. This will overwrite the `authorized_keys`
        file.
-   `FILE_PERMISSIONS`
    -   If set the given file permissions are set recursively at startup.
-   `HOST_KEY`
    -   Host key to use for the ssh server. This will overwrite the `host_key` file.

## Volumes

-   `/media/sftp`
    -   Chroot directory for sftp. Has to be writeable only by root.
-   `/media/sftp/data`
    -   Data directory of the sftp share. Writeable by the sftp user.
-   `/media/ssh/authorized_keys`
    -   Additional public keys with access to the ssh server.
-   `/media/ssh/host_key`
    -   Host key to use for the ssh server.

## Development

To run for development execute:

```bash
docker compose --file docker-compose-dev.yaml up --build
```

[base image]: https://github.com/mbT-Infrastructure/docker-base
[Docker Hub]: https://hub.docker.com/r/madebytimo/sftp-server
[Releases]: https://github.com/mbT-Infrastructure/docker-sftp-server/releases
