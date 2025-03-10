#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' 

echo -e "${RED}[👀] Reinitialize the cluster ${NC}"
sudo kubeadm reset
sudo rm -rf $HOME/.kube
sudo systemctl daemon-reload
sudo systemctl restart kubelet

echo -e "${RED}[💪] Fresh kubernetes cluster re-init ${NC}"
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 -v 4
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

