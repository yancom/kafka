# Enable Hyper-V
##Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# Delete any existing Minikube cluster
minikube delete

# Start Minikube with Docker driver
minikube start --driver=docker

# Check Minikube status
minikube status

# Use Minikube context for kubectl
kubectl config use-context minikube

# Verify nodes
kubectl get nodes

# Verify pods in all namespaces
kubectl get pods --all-namespaces
