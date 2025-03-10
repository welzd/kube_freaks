#!/bin/bash

MAGENTA='\033[0;35m'
BRIGHT_RED='\033[1;31m'
NC='\033[0m' 

echo -e "${MAGENTA}[🤖] Init the master node of the cluster ${NC}"
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 -v 4
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo ""

echo -e "${BRIGHT_RED}[👾] Applyng Calico for network management ${NC}"
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/custom-resources.yaml

echo ""

echo -e "${MAGENTA}[🧐] Check to see if all pods are in RUNNING AND READY n/n states ${NC}"
watch kubectl get pods -n calico-system

echo ""

echo -e "${BRIGHT_RED}[😣] Well if all pods are RUNNING let's remove taint from the master nodes ${NC}"
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

echo ""

echo -e "${MAGENTA}[👋] Bye buddy and be sure to join the worker nodes. Here a quickie > ${NC}"
kubeadm token create --print-join-command
