#!/bin/bash


# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/erin/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install Kubernetes tools
brew install kubectl
brew install clusterctl

# System utilities
sudo zypper install k9s btop

# User permissions
sudo usermod -aG docker erin
sudo systemctl enable --now docker.service

# Navigate to the data directory and adjust permissions
cd /data/
sudo chmod -R 777 /data

# Clone the necessary repository
cd /data
git clone https://github.com/rancher/highlander.git


# Create a Kind cluster with a specific configuration
cd /data/highlander/demos/kubecon-limited-ga/
kind create cluster --config kind-cluster-with-extramounts.yaml
kind get clusters
kind delete cluster --name demo

# Restart Docker service to ensure no issues with containers
sudo systemctl restart docker.service

# Edit the Kind configuration as needed
vi kind-cluster-with-extramounts.yaml

# Create the cluster again with the new configuration
kind create cluster --config kind-cluster-with-extramounts.yaml