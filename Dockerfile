FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ZSH="/root/.oh-my-zsh"
ENV ZSH_CUSTOM="${ZSH}/custom"
ENV PATH="/root/.local/bin:/root/.fzf/bin:/root/.cargo/bin:$PATH"
ENV TERM="xterm-256color"

ARG TARGETARCH
ARG GH_VERSION=2.67.0

# System packages
RUN apt-get update && apt-get install -y \
    zsh git curl wget htop vim docker.io bash-completion jq yq net-tools unzip bat tmux make \
    tzdata neofetch nodejs npm \
    && ln -s /usr/bin/batcat /usr/local/bin/bat \
    && ln -fs /usr/share/zoneinfo/Europe/Budapest /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Shell setup (oh-my-zsh, plugins, fzf)
RUN chsh -s $(which zsh) && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish && \
    rm -rf ${ZSH_CUSTOM}/plugins/*/.git ~/.fzf/.git

# CLI tools (zoxide, uv, duckdb, lazydocker, k9s, claude code)
RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash && \
    ln -s /root/.local/bin/zoxide /usr/local/bin/zoxide && \
    curl -fsSL https://astral.sh/uv/install.sh | sh && \
    DUCKDB_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "aarch64" || echo "$TARGETARCH") && \
    cd /tmp && \
    wget https://github.com/duckdb/duckdb/releases/download/v1.2.2/duckdb_cli-linux-${DUCKDB_ARCH}.zip && \
    unzip duckdb_cli-linux-${DUCKDB_ARCH}.zip && \
    mv duckdb /usr/local/bin/duckdb && chmod +x /usr/local/bin/duckdb && \
    rm duckdb_cli-linux-${DUCKDB_ARCH}.zip && \
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash && \
    curl -fsSL "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_${TARGETARCH}.tar.gz" | tar xz -C /usr/local/bin k9s && \
    curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${TARGETARCH}.tar.gz" | tar xz -C /tmp && \
    mv /tmp/gh_${GH_VERSION}_linux_${TARGETARCH}/bin/gh /usr/local/bin/gh && rm -rf /tmp/gh_* && \
    npm install -g @anthropic-ai/claude-code

# Tmux setup (tpm, plugins, config)
RUN git clone https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm && \
    echo "\
set -g mouse on\n\
setw -g mode-keys vi\n\
bind -T copy-mode-vi WheelUpPane send-keys -X scroll-up\n\
bind -T copy-mode-vi WheelDownPane send-keys -X scroll-down\n\
bind -T copy-mode-vi PageUp send-keys -X page-up\n\
bind -T copy-mode-vi PageDown send-keys -X page-down\n\
bind -n WheelUpPane if-shell -F -t = \"#{mouse_any_flag}\" \"copy-mode -e\"\n\
unbind -T root MouseDragEnd1Pane\n\
\n\
set -g @plugin 'tmux-plugins/tpm'\n\
set -g @plugin 'tmux-plugins/tmux-resurrect'\n\
set -g @plugin 'tmux-plugins/tmux-continuum'\n\
set -g @continuum-restore 'on'\n\
set -g @continuum-save-interval '1'\n\
set -g @resurrect-strategy-nvim 'session'\n\
run '~/.tmux/plugins/tpm/tpm'\n\
" > /root/.tmux.conf && \
    ~/.tmux/plugins/tpm/bin/install_plugins && \
    rm -rf /root/.tmux/plugins/tpm/.git

# Config files (most likely to change — keep last for cache)
COPY ./config/.zshrc /root/.zshrc
WORKDIR /workspace
CMD ["zsh"]
