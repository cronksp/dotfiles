FROM ubuntu:latest

# Install dependencies required for the install script to run
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    git \
    unzip \
    wget \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Create a test user so we aren't running as root (mimics standard devcontainer)
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser/dotfiles

# Copy the dotfiles into the container
COPY --chown=testuser:testuser . .

# Run the installation script
CMD ["/bin/bash", "./install.sh"]
