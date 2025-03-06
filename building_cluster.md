# Kube_freaks
This guide is intended to help you setup quickly a Kubernetes cluster.

**Description of the cluster**
- OS: Ubuntu 22.04
-  Master node: 1
-  Workers nodes: 3
- Num of CPU: 2
- RAM: 2GB per machine
- Disk: 100 GB per machine
= Kubernetes version: 1.31

## Kubernetes pre-setup
Before creating the cluster of one master and three workers be sure to edit the hosts file by adding the ip adress of all machines
For example :
```text
192.168.40.3 master
192.168.40.56 worker1
etc...
```

Giving permissions to the kube_prerequisities to run and prepare your environment to create a cluster
```bash
sudo chmod +x kube_prerequisities.sh
sh kube_prerequisities.sh
```
Good things are starting from here

### On the master node
**Create the cluster**
```bash
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

**Add the network plugin**
- For Calico:

Step 1: Install the Tigera Operator and custom resources
```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml
```

Step 2: Install Calico by creating the necessary resources
```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/custom-resources.yaml```
```

Step 3: Confirm that all pods are running using this command (wait until each pod has the **STATUS** of **RUNNING**)
```bash
watch kubectl get pods -n calico-system
```

Step 4: Remove the taints on the control plane so that you can schedule pods on it
```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```


- For Flannel (simple and lightweight to manage)

  ```bash
  kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
  ```
