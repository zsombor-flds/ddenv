FROM ubuntu:24.04

# Environment setup
ENV DEBIAN_FRONTEND=noninteractive \
    ZSH="/root/.oh-my-zsh" \
    ZSH_CUSTOM="/root/.oh-my-zsh/custom" \
    PATH="/root/.local/bin:/root/.fzf/bin:/root/.cargo/bin:$PATH" \
    TERM="xterm-256color"

# Install all dependencies and setup tools
RUN apt-get update && \
    apt-get install -y \
        zsh git curl wget vim python3 python3-pip python3-venv \
        docker.io bash-completion cargo jq yq bat gnupg2 \
        ca-certificates lsb-release software-properties-common \
    && apt-get clean && \
    ln -s /usr/bin/batcat /usr/local/bin/bat && \
\
# Install oh-my-zsh
    chsh -s $(which zsh) && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
\
# Install zsh plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting && \
\
# Install fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish && \
\
# Install exa and zoxide
    cargo install exa --locked && \
    ln -s /root/.cargo/bin/exa /usr/local/bin/exa && \
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash && \
    ln -s /root/.local/bin/zoxide /usr/local/bin/zoxide && \
\
# Install UV
    curl -fsSL https://astral.sh/uv/install.sh -o /uv-installer.sh && \
    chmod +x /uv-installer.sh && sh /uv-installer.sh && rm /uv-installer.sh && \
\
# Install Glow
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" > /etc/apt/sources.list.d/charm.list && \
    apt-get update && apt-get install -y glow && \
    apt-get clean

# Copy zsh config and scripts
COPY ./config/.zshrc /root/.zshrc
COPY ./scripts/run-dev.sh /usr/local/bin/run-dev.sh
COPY ./scripts/helper.sh /usr/local/bin/helper
RUN chmod +x /usr/local/bin/run-dev.sh /usr/local/bin/helper

# Set working directory and default shell
WORKDIR /workspace
CMD ["zsh"]
