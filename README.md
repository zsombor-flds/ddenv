# denv
Dockerized development environment — consistent dev setup across any VM.

## Install
```bash
curl -fsSL https://raw.githubusercontent.com/zsombor-flds/denv/main/scripts/denv_installer -o denv_installer
chmod +x denv_installer
./denv_installer install
```

Requires: Docker

## Uninstall
```bash
denv uninstall
```

## Usage
```bash
denv            # start or attach (pulls image from ghcr.io)
denv local      # use locally-built image instead
denv stop       # stop the running container
denv status     # show container status
denv install    # install denv to /usr/local/bin
denv uninstall  # remove denv from /usr/local/bin
```

## Develop
```bash
make build       # build the image locally
make run         # start with remote image
make run-local   # start with local image
make install     # install denv to /usr/local/bin
```
