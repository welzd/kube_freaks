#!/bin/bash
# This script is intended to work on the LTS version of Ubuntu 22.04
# In the future I will make that script more customizable

# Color codes section
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# The hosts file
ETC_HOSTS="/etc/hosts"

# The backup if anything crashes
BACKUP_HOSTS="/etc/hosts.bak"

# The new hosts file with all the IP addresses of the cluster
NEW_HOSTS="./hosts"

# Packages update
echo "${GREEN}[+] Packages update ${NC}"
sudo apt-get update

# Packages upgrade
echo "${GREEN}[+] Packages upgrade ${NC}"
sudo apt-get upgrade

# Changing the hostname to fit the needs 
echo "${GREEN}[+] Hostname changing ${NC}"
read -p "Modify the hostname(default=master) : " new_hostname
new_hostname=${new_hostname:-master}
sudo hostnamectl set-hostname $new_hostname

# First let's backup the /etc/hosts file
echo "${GREEN}[+] Creating a backup file for the hosts file ${NC}"
sudo cp $ETC_HOSTS $BACKUP_HOSTS

# Cleaning the content of the original hosts file and 
echo "${YELLOW}[+] Making changes to the hosts file ${NC}"
sudo mv $NEW_HOSTS $ETC_HOSTS

# Turn the swap off even at startup
echo "${YELLOW}[+] Turn the swap off even at reboot ${NC}"
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a 

# Installing the container runtime and enable it at startup
echo "${GREEN}[+] Container runtime setup (containerd) ${NC}"
sudo apt-get install containerd
sudo systemctl enable containerd

# Charging modules for containerd
echo "${GREEN}[+] Setting up the modules for containerd ${NC}"
echo "overlay \nbr_netfilter" | sudo tee /etc/modules-load.d/containerd.conf > /dev/null
sudo modprobe overlay
sudo modprobe br_netfilter

# Starting the container runtime
echo "${YELLOW}[+] Starting the CRI ${NC}"
sudo systemctl start containerd

# Setting systemd cgroup drivers
echo "${GREEN}[+] Systemd Cgroup drivers setup ${NC}"
sudo mkdir /etc/containerd
sudo containerd config default > config.toml
sudo mv config.toml /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml



# Install the CNI plugin for containerd nertwork purpose
echo "${GREEN}[+] Running containerd setup ${NC}"
sudo apt-get install curl
wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz
mkdir -p /opt/cni/bin  
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz
sudo curl -L https://raw.githubusercontent.com/containerd/containerd/main/containerd.service -o /etc/systemd/system/containerd.service

# Changing the executable path of containerd
echo "${GREEN}[+] Writing changes to the binary of the containerd.service ${NC}"
sudo sed -i 's/ExecStart=usr/local/bin/containerd/ ExecStart=usr/bin/containerd/' /etc/systemd/system/containerd.service

sudo systemctl daemon-reload
sudo systemctl restart containerd

# Enable IPv4 packet forwarding
echo "${YELLOW}[+] Enabling IPv4 packet forwarding  ${NC}"
echo "net.ipv4.ip_forward = 1 \nnet.bridge.bridge-nf-call-iptables = 1" | sudo tee /etc/sysctl.d/k8s.conf > /dev/null
echo "${YELLOW}[+] Applying the changes to the system  ${NC}"
sudo sysctl --system

# Installing the kube tools - kubelet kubeadm kubectl
echo "${GREEN}[+] Dependencies setup  ${NC}"
sudo apt-get install apt-transport-https ca-certificates curl gpg

echo "${YELLOW}[+] Adding keyrings ${NC}"
[ -d /etc/apt/keyrings ] || sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "${YELLOW}[+] Adding the Kubernetes apt repository ${NC}"
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "${GREEN}[+] Installing Kubernetes tools and enabling kubelet ${NC}"
sudo apt-get update
sudo apt-get install kubeadm kubelet kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

echo "${GREEN}[+] Adding firewall rules ${NC}"
sudo ufw allow 2379/tcp
sudo ufw allow 2380/tcp
sudo ufw allow 8080/tcp
sudo ufw allow 6443/tcp
sudo ufw allow 10250/tcp
sudo ufw allow 10257/tcp
sudo ufw allow 10259/tcp
