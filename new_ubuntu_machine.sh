!/bin/bash

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install Brave Browser
sudo apt install -y apt-transport-https curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser

# Install essential build tools
sudo apt install -y build-essential curl file git

# Install Node Version Manager (NVM)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Install latest version of Node.js
nvm install node

# Install global NPM packages
npm install -g yarn

# Install VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code

# Install MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt update
sudo apt install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod

# Install PostgreSQL
sudo apt install -y postgresql postgresql-contrib
sudo apt-get install xclip -yer and database
sudo -u postgres psql -c "CREATE USER devuser WITH PASSWORD 'password';"
sudo -u postgres psql -c "CREATE DATABASE devdb OWNER devuser;"

# Install Redis
sudo apt install -y redis-server

# Start Redis
sudo systemctl enable redis-server.service
sudo systemctl start redis-server.service

# Install MySQL
sudo apt install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql

# Setup MySQL user and database
sudo mysql -e "CREATE USER 'devuser'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -e "CREATE DATABASE devdb;"
sudo mysql -e "GRANT ALL PRIVILEGES ON devdb.* TO 'devuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Install Zsh and Oh My Zsh
sudo apt install zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s $(which zsh)

# NVM setup
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"
EOL

# Install Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker ${USER}

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Docker Desktop prerequisites
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key and set up the stable repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Fetch the latest version of Docker Desktop
latest_docker_desktop_version=$(curl -s https://api.github.com/repos/docker/desktop/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')

# Download the latest Docker Desktop .deb package
curl -LO https://desktop.docker.com/linux/main/amd64/docker-desktop-$latest_docker_desktop_version-amd64.deb

# Install Docker Desktop .deb package
sudo apt-get install -y ./docker-desktop-$latest_docker_desktop_version-amd64.deb

# Start Docker Desktop
systemctl --user start docker-desktop
systemctl --user enable docker-desktop
# Install Python
sudo apt install -y python3 python3-pip

# Install Ruby
sudo apt install -y ruby-full

# Install PHP
sudo apt install -y php libapache2-mod-php php-cli php-cgi php-mysql php-pgsql

# Install Go
sudo rm -rf /usr/local/go
latest_go_version=$(curl -s https://go.dev/VERSION?m=text)
wget "https://go.dev/dl/${latest_go_version}.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "${latest_go_version}.linux-amd64.tar.gz"
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
source ~/.zshrc

# Clean up
sudo apt autoremove -y
sudo apt autoclean -y

echo "Setup complete! Please restart your terminal or log out and log back in to apply changes."
