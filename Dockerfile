FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ZSH="/root/.oh-my-zsh"
ENV ZSH_CUSTOM="${ZSH}/custom"
ENV PATH="/root/.local/bin:/root/.fzf/bin:/root/.cargo/bin:$PATH"
ENV TERM xterm-256color

RUN apt-get update && apt-get install -y \
    zsh git curl wget vim python3 python3-pip python3-venv docker.io bash-completion cargo \
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

# Copy custom zshrc
COPY ./config/.zshrc /root/.zshrc

# Persistent Zsh history
VOLUME ["/root/.zsh_history"]

# Install UV
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN chmod +x /uv-installer.sh && sh /uv-installer.sh && rm /uv-installer.sh

WORKDIR /workspace
CMD ["zsh"]
