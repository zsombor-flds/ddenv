# ddenv
Dockerized development environment — consistent dev setup across any VM.

## Install
```bash
curl -fsSL https://raw.githubusercontent.com/zsombor-flds/ddenv/main/scripts/ddenv \
  | sudo tee /usr/local/bin/ddenv > /dev/null && sudo chmod +x /usr/local/bin/ddenv
```

Requires: Docker

## Usage
```bash
ddenv            # start or attach (pulls image from ghcr.io)
ddenv local      # use locally-built image instead
ddenv stop       # stop the running container
ddenv status     # show container status
```

## Develop
```bash
make build       # build the image locally
make run         # start with remote image
make run-local   # start with local image
make install     # install ddenv to /usr/local/bin
```
