FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ZSH="/root/.oh-my-zsh"
ENV ZSH_CUSTOM="${ZSH}/custom"
ENV PATH="/root/.local/bin:/root/.fzf/bin:/root/.cargo/bin:$PATH"
ENV TERM="xterm-256color"

RUN apt-get update && apt-get install -y \
    zsh git curl wget htop vim docker.io bash-completion jq yq net-tools unzip bat tmux make \
    tzdata \
    && ln -s /usr/bin/batcat /usr/local/bin/bat \
    && ln -fs /usr/share/zoneinfo/Europe/Budapest /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean

# Install oh-my-zsh
RUN chsh -s $(which zsh) && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting

# Install fzf with keybindings and completion
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# # Install exa with locked dependencies (for older rustc compatibility)
# RUN cargo install exa --locked && \
#     ln -s /root/.cargo/bin/exa /usr/local/bin/exa

# Install zoxide and symlink globally
RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash && \
    ln -s /root/.local/bin/zoxide /usr/local/bin/zoxide

# Install UV
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN chmod +x /uv-installer.sh && sh /uv-installer.sh && rm /uv-installer.sh

# Install Glow
# RUN mkdir -p /etc/apt/keyrings && \
#     curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg && \
#     echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | tee /etc/apt/sources.list.d/charm.list && \
#     apt update && apt install glow

# Install DuckDB
WORKDIR /opt/duckdb

RUN wget https://github.com/duckdb/duckdb/releases/download/v1.2.2/duckdb_cli-linux-aarch64.zip

# Unzip and move to /usr/local/bin
RUN unzip duckdb_cli-linux-aarch64.zip && \
    mv duckdb /usr/local/bin/duckdb && \
    chmod +x /usr/local/bin/duckdb && \
    rm duckdb_cli-linux-aarch64.zip

# Install tmux plugin manager (TPM)
RUN git clone https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm

# Create a basic tmux.conf with resurrect and continuum
RUN echo "\
set -g @plugin 'tmux-plugins/tpm'\n\
set -g @plugin 'tmux-plugins/tmux-resurrect'\n\
set -g @plugin 'tmux-plugins/tmux-continuum'\n\
set -g @continuum-restore 'on'\n\
set -g @resurrect-strategy-nvim 'session'\n\
run '~/.tmux/plugins/tpm/tpm'\n\
" > /root/.tmux.conf

RUN ~/.tmux/plugins/tpm/bin/install_plugins

# Copy custom zshrc
COPY ./config/.zshrc /root/.zshrc

# Copy helper entrypoint
COPY ./scripts/run-dev.sh /usr/local/bin/run-dev.sh
COPY ./scripts/helper.sh /usr/local/bin/helper
RUN chmod +x /usr/local/bin/run-dev.sh /usr/local/bin/helper

WORKDIR /workspace
CMD ["zsh"]
