#!/bin/bash

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Check if Homebrew was installed successfully
if command -v brew &> /dev/null
then
    echo "Homebrew installed successfully"
else
    echo "Homebrew installation failed"
    exit 1
fi

# Update and upgrade Homebrew
brew update && brew upgrade

# XCode Command Line Tools: Install if not already present.
echo "Checking for Xcode Command Line Tools..."
if ! xcode-select -p >/dev/null 2>&1; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
else
    echo "Xcode Command Line Tools already installed."
fi

# Finder Configuration: Set up Finder preferences like showing hidden files.
echo "Configuring Finder settings..."
chflags nohidden ~/Library
defaults write com.apple.finder AppleShowAllFiles YES
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Restart Finder to apply changes using AppleScript.
osascript -e 'tell application "Finder" to quit'
osascript -e 'tell application "Finder" to launch'

echo "Installing iTerm2..."
brew install --cask --appdir="/Applications" iterm2

#wget
brew install wget
# Install Brave Browser
brew install --cask brave-browser

# Install essential build tools
brew install git curl

# Install Node Version Manager (NVM)
brew install nvm
mkdir ~/.nvm
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"' >> ~/.zshrc
eval "$(rbenv init - --)"
# Install latest version of Node.js
nvm install node

# Install global NPM packages
npm install -g yarn

# Install VS Code
brew install --cask visual-studio-code

# Install MongoDB
brew tap mongodb/brew
brew install mongodb-community@5.0

# Start MongoDB
brew services start mongodb/brew/mongodb-community

# Install PostgreSQL
brew install postgresql
brew services start postgresql
createuser -s postgres

# Install Redis
brew install redis
brew services start redis

# Install MySQL
brew install mysql
brew services start mysql

# Setup MySQL user and database
mysql -u root -e "CREATE USER 'root'@'localhost' IDENTIFIED BY 'root';"
mysql -u root -e "CREATE DATABASE devdb;"
mysql -u root -e "GRANT ALL PRIVILEGES ON devdb.* TO 'root'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Install Zsh and Oh My Zsh
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Docker
brew install --cask docker
open /Applications/Docker.app

# Install Python
brew install python

# Install Ruby
brew install ruby

# Install PHP
brew install php

# Get the latest Go version (extracting only the version part)
latest_go_version=$(curl -s https://go.dev/VERSION?m=text | head -n 1)

# Download the latest Go version
wget "https://go.dev/dl/${latest_go_version}.darwin-amd64.tar.gz"

# Remove any previous Go installation (again for safety)
sudo rm -rf /usr/local/go

# Extract the downloaded tarball
sudo tar -C /usr/local -xzf "${latest_go_version}.darwin-amd64.tar.gz"

# Add Go to the PATH
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc

# remove tar
rm -rf "${latest_go_version}.darwin-amd64.tar.gz"

# Apply the new PATH within the script
export PATH=$PATH:/usr/local/go/bin
# Verify the Go installation
go version

# Fast and git-friendly opensource API client
brew install bruno

# Kubernetes
brew install kubectl
kubectl version --client

# AWS
brew install awscli

# dbeaver
brew install --cask dbeaver-community

# Check if DBeaver is in the Applications folder
if [ ! -d "/Applications/DBeaver.app" ]; then
    mv /Applications/DBeaver.app /Applications
else
    echo "DBeaver is already in the Applications folder."
fi

# 1password
brew install --cask 1password

# Postman
brew install --cask postman

# Notion
brew install --cask notion
# Clean up
brew cleanup

# Make ~/Projects directory
cd ~ && mkdir Projects && cd Projects

echo "Setup complete! Please restart your terminal or log out and log back in to apply changes."
