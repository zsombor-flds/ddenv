#!/bin/bash
# Helper to scaffold or enter a development environment in a Docker container
set -e

# Check for argument
if [[ "$1" == "local" ]]; then
  IMAGE_NAME="denv"
else
  IMAGE_NAME="ghcr.io/zsombor-flds/denv"
fi

# Define paths
HISTFILE="$HOME/denv/.docker_zsh_history"
WORKSPACE="$HOME/workspace"
GITCONFIG="$HOME/.gitconfig"
SSH_DIR="$HOME/.ssh"
TMUX_RESURRECT_DIR="$HOME/denv/tmux"

# Create parent dir for history file
mkdir -p "$(dirname "$HISTFILE")"
touch "$HISTFILE"

echo "denv configs:"
echo "- image: $IMAGE_NAME"
echo "- workspace: $WORKSPACE"
echo "- history file: $HISTFILE"
echo "- gitconfig: $GITCONFIG"
echo "- SSH dir (read-only): $SSH_DIR"

# Check if container is already running
if docker ps --format '{{.Names}}' | grep -q "^denv$"; then
  echo "Container 'denv' is already running. Attaching..."
  docker exec -it denv zsh
else
  echo "Starting new Docker development environment..."
  docker run -it \
    --rm \
    --name denv \
    --network=host \
    --privileged \
    -v "$WORKSPACE":/workspace \
    -v "$HISTFILE":/root/.zsh/history \
    -v "$GITCONFIG":/root/.gitconfig:ro \
    -v "$SSH_DIR":/root/.ssh:ro \
    -v "$TMUX_RESURRECT_DIR/:/root/.tmux/resurrect" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    "$IMAGE_NAME" \
    zsh
fi
