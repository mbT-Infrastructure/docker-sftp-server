# sftp-server image

This Docker image contains a simple ssh server which only allows sftp for the user `sftp`.


## Environment variables

- `AUTHORIZED_PUBLIC_KEYS`
    - Public keys with access to the ssh server. For example `ssh-rsa AAAAB3Nz... user@example.madebytimo.de`.
- `FILE_PERMISSIONS`
    - If not empty the given file permissions are set recursively at startup, default `777`.
- `HOST_KEY`
    - Host key to use for the ssh server.


## Volumes

- `/media/sftp`
    - Contains all data of the sftp share.


## Development

To build and run for development run:
```bash
docker compose --file docker-compose-dev.yaml up --build
```

To build the image locally run:
```bash
./docker-build.sh
```
