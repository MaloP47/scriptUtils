#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Updating and upgrading the system..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "Installing Git..."
sudo apt-get install -y git

echo "Installing dependencies for Docker..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "Adding Docker’s official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "Setting up the Docker stable repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing Docker Engine..."
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "Adding $USER to the docker group..."
sudo usermod -aG docker "$USER"

echo "Installing Zsh..."
sudo apt-get install -y zsh

echo "Installing Oh My Zsh..."
# The install script is interactive; we use '|| true' to allow the script to continue if it tries to exit.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

ZSHRC_FILE="$HOME/.zshrc"

echo "Setting Oh My Zsh theme to dpoggi in $ZSHRC_FILE..."
sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="dpoggi"/g' "$ZSHRC_FILE"

echo "Ensuring Zsh is your default shell..."
chsh -s "$(which zsh)" "$USER"

echo "Installing lazydocker..."
# 1) Grab the latest lazydocker version from the GitHub API
# 2) Download the tarball for the Linux x86_64 build
# 3) Extract and move to /usr/local/bin
LAZYDOCKER_VERSION=$(curl --silent "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"([^"]+)".*/\1/')
curl -Lo lazydocker.tar.gz \
  "https://github.com/jesseduffield/lazydocker/releases/download/${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION#v}_Linux_x86_64.tar.gz"
tar xzf lazydocker.tar.gz lazydocker
sudo mv lazydocker /usr/local/bin/
rm lazydocker.tar.gz

echo "Creating alias 'lzd' -> 'lazydocker' in $ZSHRC_FILE..."
echo "alias lzd='lazydocker'" >> "$ZSHRC_FILE"

echo "Sourcing your .zshrc to load the new configuration..."
# If you’re still in bash, this might not fully apply; but it will run through the .zshrc commands once.
source "$ZSHRC_FILE" || true

echo "Rebooting now..."
sudo reboot
