#!/bin/bash
# Helper to scaffold a development environment in a Docker container
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

echo "Docker development environment started with:"
echo "Using image: $IMAGE_NAME"
echo "Using workspace: $WORKSPACE"
echo "Using history file: $HISTFILE"
echo "Using gitconfig: $GITCONFIG"
echo "Using SSH dir (read-only): $SSH_DIR"

# Run Docker container
  # --restart=unless-stopped \
docker run -it \
  --rm \
  --name denv \
  --network=host \
  --privileged \
  -v "$WORKSPACE":/workspace \
  -v "$HISTFILE":/root/.zsh/history \
  -v "$GITCONFIG":/root/.gitconfig:ro \
  -v "$SSH_DIR":/root/.ssh:ro \
  -v "$TMUX_RESURRECT_DIR:/root/.tmux/resurrect" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  "$IMAGE_NAME" \
  zsh
