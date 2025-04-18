# === Oh My Zsh ===
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# === History Config ===
export HISTFILE="$HOME/.zsh/history"
export HISTSIZE=1000000000
export HISTFILESIZE=1000000000

setopt append_history
setopt inc_append_history
setopt share_history
setopt no_hist_save_by_copy
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS

# === Aliases ===
alias python='/usr/bin/python3'
alias pip='/usr/bin/pip3'
# alias ls='exa --no-icons'
alias cat='bat --style=plain'
alias helper='glow /usr/local/bin/run-helper.sh'
alias gpull='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias gpush='git push origin HEAD'
alias gc='git clone'
alias gs='git checkout -B'
alias dev='find . -name "notes.md" -exec glow {} +'
alias activate='source .venv/bin/activate'

# === Completions & FZF ===
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && source "/usr/local/etc/profile.d/bash_completion.sh"
[[ -f "$HOME/.fzf/shell/key-bindings.zsh" ]] && source "$HOME/.fzf/shell/key-bindings.zsh"
[[ -f "$HOME/.fzf/shell/completion.zsh" ]] && source "$HOME/.fzf/shell/completion.zsh"
export PATH="$HOME/.fzf/bin:$PATH"

# === zoxide ===
eval "$(zoxide init zsh)"
