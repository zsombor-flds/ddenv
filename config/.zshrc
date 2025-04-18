export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# History config
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000000
export HISTFILESIZE=1000000000
setopt append_history
setopt inc_append_history
setopt share_history
setopt no_hist_save_by_copy
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS

# Aliases
alias python='/usr/bin/python3'
alias pip='/usr/bin/pip3'
alias ls='exa --icons'
alias cat='bat --style=plain'
alias helper='glow /usr/local/bin/run-helper.sh'

# Optional completions and fuzzy finder
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -f ~/.fzf/shell/key-bindings.zsh ]] && source ~/.fzf/shell/key-bindings.zsh
[[ -f ~/.fzf/shell/completion.zsh ]] && source ~/.fzf/shell/completion.zsh
export PATH="$HOME/.fzf/bin:$PATH"

# zoxide initialization
eval "$(zoxide init zsh)"
