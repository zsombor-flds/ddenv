#!/bin/bash

set -e

# Ensure history file exists
# HISTFILE="$HOME/.docker_zsh_history"
HISTFILE="$PWD/.docker_zsh_history"
touch "$HISTFILE"

# Build and run the container
docker build -t my-dev-env . && \
docker run -it \
  -v "$PWD":/workspace \
  -v "$HISTFILE":/root/.zsh_history \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --privileged \
  my-dev-env
