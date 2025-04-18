#!/bin/bash
# Helper to run the scaffold a development environment in a Docker container
set -e

# Ensure history file exists
HISTFILE="$PWD/.docker_zsh_history"
touch "$HISTFILE"

# Build and run the container
docker build -t my-dev-env . && \
docker run -it \
  -v "$PWD":/workspace \
  -v "$HISTFILE":/root/.zsh_history \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --privileged \
  my-dev-env \
  zsh
