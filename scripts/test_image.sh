#!/bin/bash
# Test that all tools in the denv image are installed and working
set -e

IMAGE="${1:-denv}"
FAIL=0

check() {
  local name="$1"
  shift
  if output=$("$@" 2>&1); then
    printf "  %-25s OK    %s\n" "$name" "$(echo "$output" | head -1)"
  else
    printf "  %-25s FAIL\n" "$name"
    FAIL=1
  fi
}

echo "Testing image: $IMAGE"
echo ""

echo "=== System tools ==="
docker run --rm "$IMAGE" bash -c '
check() {
  local name="$1"; shift
  if output=$("$@" 2>&1); then
    printf "  %-25s OK    %s\n" "$name" "$(echo "$output" | head -1)"
  else
    printf "  %-25s FAIL\n" "$name"
    exit 1
  fi
}

check "zsh"              zsh --version
check "git"              git --version
check "curl"             curl --version
check "wget"             wget --version
check "htop"             htop --version
check "vim"              vim --version
check "docker"           docker --version
check "jq"               jq --version
check "yq"               yq --version
check "bat"              bat --version
check "tmux"             tmux -V
check "make"             make --version
check "node"             node --version
check "npm"              npm --version
check "neofetch"         which neofetch

echo ""
echo "=== CLI tools ==="
check "zoxide"           zoxide --version
check "uv"               uv --version
check "duckdb"           duckdb --version
check "lazydocker"       lazydocker --version
check "k9s"              k9s version --short
check "gh"               gh --version
check "claude"           claude --version

echo ""
echo "=== Shell plugins ==="
check "oh-my-zsh"        test -d ~/.oh-my-zsh
check "zsh-autosuggestions"      test -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
check "zsh-syntax-highlighting"  test -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
check "fast-syntax-highlighting" test -d ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
check "fzf"              ~/.fzf/bin/fzf --version

echo ""
echo "=== Tmux plugins ==="
check "tpm"              test -d ~/.tmux/plugins/tpm
check "tmux-resurrect"   test -d ~/.tmux/plugins/tmux-resurrect
check "tmux-continuum"   test -d ~/.tmux/plugins/tmux-continuum
'

echo ""
echo "All checks passed."
