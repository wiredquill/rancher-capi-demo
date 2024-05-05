
# Development Environment Setup Guide

This guide details the steps to establish a robust development environment for Kubernetes on a Linux system using tools like Homebrew, Kind, and Docker.

## Prerequisites
- Linux-based operating system
- User account with sudo or root access

## Installation Steps (Run as a users - Example uses 'erin')

### 1. Install System Utilities
Install essential utilities for system monitoring and Kubernetes management:

k9s - nice commandline k8s interface
btop - mem and cpu ussage.... Trust me, just run `btop` and you will understand

```bash
sudo zypper install -y k9s btop docker docker-compose
```

### 2. Install Homebrew
Homebrew is a versatile package manager for Linux and macOS. To install Homebrew and configure it for immediate use:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Setup brew env in your .bashrc
```
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
```

```
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### 3. Install Kubernetes Tools
Using Homebrew, install tools necessary for Kubernetes management:
#!/bin/bash

# Install kubectl helm clusterctl kind

clusterctl - a utiltiy that is need to talk to the CAPI API 
kind - k8s in docker - Note this is temp until we swap this out to k3d or something

```
brew install kubectl helm clusterctl kind
```

### 4. Configure User Permissions
Add user 'erin' to the Docker group to manage Docker without root privileges
```bash
sudo usermod -aG docker erin
```

Start Docker and have it run automatically:
```
sudo systemctl enable --now docker.service
```

### 5. Prepare Data Directory
Set up the `/data` directory and clone the necessary Kubernetes configurations:
```bash
sudo mkdir -p /data
```
```
sudo chmod -R 777 /data
```

```
cd /data
```

clone the repo with demo files
```
git clone https://github.com/wiredquill/rancher-capi-demo.git
```

### 6. Manage Kubernetes Cluster with Kind
Manage your Kubernetes cluster configurations and operations using Kind:
```bash
cd /data/rancher-capi-demo/Kind-Rancher
```
Create the instance of K8s in Kind that we will use as our main Rancher K8s instance
```
kind create cluster --config kind-cluster-with-extramounts.yaml
```
Make sure the cluster is up
```
kind get clusters
```

## If you need to delete the cluster `kind delete cluster --name demo`

# Restart Docker service to ensure no container issues
sudo systemctl restart docker.service





## Conclusion
Following these detailed steps will equip you with a functional and flexible Kubernetes development environment. This setup enables effective management and deployment of Kubernetes clusters using a variety of essential tools.
