# sftp-server image

This Docker image contains a simple ssh server which only allows sftp for the user `sftp`.


## Environment variables

- `HOST_KEY`
    - Host key to use for the ssh server.
- `AUTHORIZED_PUBLIC_KEYS`
    - Public keys with access to the ssh server. For example `ssh-rsa AAAAB3Nz... user@example.madebytimo.de`.


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
