FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ZSH="/root/.oh-my-zsh"
ENV ZSH_CUSTOM="${ZSH}/custom"
ENV PATH="/root/.local/bin:/root/.fzf/bin:/root/.cargo/bin:$PATH"
ENV TERM="xterm-256color"

RUN apt-get update && apt-get install -y \
    zsh git curl wget vim python3 python3-pip python3-venv docker.io bash-completion cargo jq yq \
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

# Install bat
RUN apt-get install -y bat && \
    ln -s /usr/bin/batcat /usr/local/bin/bat

# Install exa with locked dependencies (for older rustc compatibility)
RUN cargo install exa --locked && \
    ln -s /root/.cargo/bin/exa /usr/local/bin/exa

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

# Copy custom zshrc
COPY ./config/.zshrc /root/.zshrc

# Copy helper entrypoint
COPY ./scripts/run-dev.sh /usr/local/bin/run-dev.sh
COPY ./scripts/helper.sh /usr/local/bin/helper
RUN chmod +x /usr/local/bin/run-dev.sh /usr/local/bin/helper

WORKDIR /workspace
CMD ["zsh"]
