#!/bin/bash
# Taken from https://phoenixnap.com/kb/install-kubernetes-on-ubuntu
# By Matt Genelin - July 14 2021
host=$(hostname)
sudo apt-get update
sudo apt-get install docker.io
docker version
echo "Press enter to continue..."
read -r

sudo systemctl enable docker
sudo systemctl status docker
sudo systemctl start docker
echo "Press enter to continue..."
read -r

sudo apt-get install -y curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository -y "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get install -y kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl
kubeadm version
echo "Press enter to continue..."
read -r

sudo swapoff –a
sudo hostnamectl set-hostname $(hostname)
exit 0

# Master node only
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Step 9: Deploy Pod Network to Cluster
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl get pods --all-namespaces

# Step 10: Join Worker Node to Cluster
## Use the Tokens from the Master server from step 7:
# kubeadm join --discovery-token abcdef.1234567890abcdef --discovery-token-ca-cert-hash sha256:1234..cdef 1.2.3.4:6443
kubectl get nodes

