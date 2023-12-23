#!/bin/bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=21
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update
sudo apt-get install nodejs -y
node -v
npm -v
# Add Docker's official GPG key:
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
## YOU NEED TO LOGOUT AND LOGIN BACK
npm install --save-dev hardhat
wget https://github.com/ethereum/solidity/releases/download/v0.5.17/solc-static-linux
chmod +x solc-static-linux
sudo cp solc-static-linux /usr/bin/
sudo cp solc-static-linux /usr/local/bin
npx quorum-dev-quickstart
cd quorum-test-network
./run.sh
## YOU NEED TO ENTER FEW DETAILS TO SETUP QUORUM
cd ..
git clone https://github.com/Consensys/cakeshop.git
cd cakeshop/quorum-dev-quickstart
docker compose up -d
cd
wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.13.7-c3d9ca62.tar.gz
tar -xvf geth-linux-amd64-1.13.7-c3d9ca62.tar.gz
cd geth-linux-amd64-1.13.7-c3d9ca62
sudo cp geth /usr/local/bin/
sudo cp geth /usr/bin/
