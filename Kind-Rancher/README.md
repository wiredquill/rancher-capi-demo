
# Development Environment Setup Guide

This guide details the steps to establish a robust development environment for Kubernetes on a Linux system using tools like Homebrew, Kind, and Docker.

## Prerequisites
- Linux-based operating system
- User account with sudo or root access

## Installation Steps (Run as a users - Example uses 'erin')

### 1. Install System Utilities
Install essential utilities for system monitoring and Kubernetes management:
```bash
sudo zypper install k9s btop docker  # 'k9s' for Kubernetes management, 'btop' for monitoring, and 'docker'
```

### 2. Install Homebrew
Homebrew is a versatile package manager for Linux and macOS. To install Homebrew and configure it for immediate use:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/erin/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### 3. Install Kubernetes Tools
Using Homebrew, install tools necessary for Kubernetes management:
```bash
brew install kubectl       # Command-line tool for Kubernetes
brew install clusterctl    # CLI tool to manage lifecycle of Kubernetes clusters
brew install helm          # Helps manage Kubernetes applications
```



### 4. Configure User Permissions
Add user 'erin' to the Docker group to manage Docker without root privileges and ensure Docker starts automatically:
```bash
sudo usermod -aG docker erin
sudo systemctl enable --now docker.service
```

### 5. Prepare Data Directory
Set up the `/data` directory and clone the necessary Kubernetes configurations:
```bash
sudo mkdir -p /data
sudo chmod -R 777 /data
cd /data
git clone [https://github.com/rancher/highlander.git](https://github.com/wiredquill/rancher-capi-demo.git)
```

### 6. Manage Kubernetes Cluster with Kind
Manage your Kubernetes cluster configurations and operations using Kind:
```bash
cd /data/rancher-capi-demo/Kind-Rancher
kind create cluster --config kind-cluster-with-extramounts.yaml
kind get clusters
kind delete cluster --name demo

# Restart Docker service to ensure no container issues
sudo systemctl restart docker.service

# Edit the Kind configuration file
vi kind-cluster-with-extramounts.yaml

# Recreate the cluster with the updated configuration
kind create cluster --config kind-cluster-with-extramounts.yaml
```

## Conclusion
Following these detailed steps will equip you with a functional and flexible Kubernetes development environment. This setup enables effective management and deployment of Kubernetes clusters using a variety of essential tools.
