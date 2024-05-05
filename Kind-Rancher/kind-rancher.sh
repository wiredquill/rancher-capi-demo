#!/bin/bash

# Enable and start Docker service
systemctl enable --now docker

# Add user 'erin' to the docker group
usermod -aG docker erin

# Download the appropriate kind binary if the system is x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64

# Make the kind binary executable
chmod +x ./kind

# Move the kind binary to a system path
mv ./kind /usr/local/bin/kind

# Navigate to /data directory, create if it doesn't exist
mkdir -p /data

# Change permissions to make everything under /data accessible
chmod -R 777 /data




