
# Manual Rancher Deployment Guide

This guide details the manual steps for deploying Rancher on a Kubernetes cluster, using Kind, Helm, and Ngrok. This approach allows you to control each step of the deployment and adjust configurations as needed.

## Prerequisites
- **Bash** or a similar shell environment.
- **Kubernetes CLI** (`kubectl`) installed and configured.
- **Helm** installed and configured to manage Kubernetes applications.
- **Kind** installed for creating a local Kubernetes cluster.
- **Ngrok** account for exposing your local Kubernetes cluster to the internet.

## Configuration

1. **Set Environment Variables**:
   Ensure the following environment variables are set according to your environment:
   - `RANCHER_HOSTNAME`: Hostname for your Rancher instance.
   - `NGROK_AUTHTOKEN`: Your Ngrok authtoken.
   - `NGROK_API_KEY`: Your Ngrok API key.

   Example:
   ```
   export RANCHER_HOSTNAME="your-rancher-hostname"
   export NGROK_AUTHTOKEN="your-ngrok-authtoken"
   export NGROK_API_KEY="your-ngrok-api-key"
   ```

## Deployment Steps

1. **Create a Kubernetes Cluster with Kind**:
   Use Kind to create a new Kubernetes cluster. You can specify a configuration file to customize your cluster.
   ```
   kind create cluster --config kind-cluster-with-extramounts.yaml
   ```

2. **Check CoreDNS Deployment**:
   Ensure that the CoreDNS deployment is successfully rolled out.
   ```
   kubectl rollout status deployment coredns -n kube-system --timeout=90s
   ```

3. **Add Required Helm Repositories**:
   Add the necessary Helm repositories for deploying Cert Manager, Rancher, and Ngrok.
   ```
   helm repo add jetstack https://charts.jetstack.io
   helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
   helm repo add ngrok https://ngrok.github.io/kubernetes-ingress-controller
   helm repo update
   ```

4. **Install Ngrok Ingress Controller**:
   Deploy the Ngrok Kubernetes Ingress Controller using Helm.
   ```
   helm install ngrok ngrok/kubernetes-ingress-controller \
       --set credentials.apiKey="$NGROK_API_KEY" \
       --set credentials.authtoken="$NGROK_AUTHTOKEN" \
       --wait
   ```

5. **Deploy Cert Manager**:
   Install Cert Manager to manage certificates within the cluster.
   ```
   helm install cert-manager jetstack/cert-manager \
       --namespace cert-manager \
       --create-namespace \
       --version v1.12.3 \
       --set installCRDs=true \
       --wait
   ```

6. **Deploy Rancher**:
   Install Rancher using Helm in the `cattle-system` namespace.
   ```
   helm install rancher rancher-latest/rancher \
       --namespace cattle-system \
       --create-namespace \
       --set bootstrapPassword=rancheradmin \
       --set replicas=1 \
       --set hostname="$RANCHER_HOSTNAME" \
       --set global.cattle.psp.enabled=false \
       --version "$RANCHER_VERSION" \
       --wait
   ```

7. **Apply Ingress Configurations for Rancher**:
   Apply the necessary ingress configurations to expose Rancher.
   ```
   kubectl apply -f ./rancher-ingress/ingress-class-patch.yaml --server-side
   kubectl apply -f ./rancher-ingress/ingress.yaml
   kubectl apply -f ./rancher-ingress/rancher-service-patch.yaml --server-side
   ```

## Conclusion

Follow these steps carefully to manually deploy Rancher on a local Kubernetes cluster. If you encounter any issues during the setup, review the configurations and ensure all prerequisites are met.

## License

Licensed under the Apache License, Version 2.0. You may not use this file except in compliance with the License. You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).
