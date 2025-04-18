#!/bin/bash
# Helper to scaffold a development environment in a Docker container
set -e

# Define paths
HISTFILE="$HOME/denv/.docker_zsh_history"
WORKSPACE="$HOME/code/"

# Create parent dir for history file
mkdir -p "$(dirname "$HISTFILE")"
touch "$HISTFILE"

echo "Docker development environment started with:"
echo "Using workspace: $WORKSPACE"
echo "Using history file: $HISTFILE"

# Run Docker container
docker run -it \
  -v "$WORKSPACE":/workspace \
  -v "$HISTFILE":/root/.zsh/history \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --privileged \
  my-dev-env \
  zsh