#!/bin/bash
# Helper to scaffold a development environment in a Docker container
set -e

# Define paths
HISTFILE="$HOME/denv/.docker_zsh_history"
WORKSPACE="$HOME/workspace"
GITCONFIG="$HOME/.gitconfig"
SSH_DIR="$HOME/.ssh"
IMAGE_NAME="ghcr.io/zsombor-flds/denv"

# Create parent dir for history file
mkdir -p "$(dirname "$HISTFILE")"
touch "$HISTFILE"


echo "Docker development environment started with:"
echo "Using workspace: $WORKSPACE"
echo "Using history file: $HISTFILE"
echo "Using gitconfig: $GITCONFIG"
echo "Using SSH dir (read-only): $SSH_DIR"

# Run Docker container
docker run -it \
  --rm \
  --name denv \
  --network=host \
  --privileged \
  -v "$WORKSPACE":/workspace \
  -v "$HISTFILE":/root/.zsh/history \
  -v "$GITCONFIG":/root/.gitconfig:ro \
  -v "$SSH_DIR":/root/.ssh:ro \
  -v /var/run/docker.sock:/var/run/docker.sock \
  "$IMAGE_NAME" \
  zsh
