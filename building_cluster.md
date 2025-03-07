# Kube_freaks
This guide is intended to help you setup quickly a Kubernetes cluster.

**Description of the cluster**
- OS: Ubuntu 22.04
- Master node: 1
- Workers nodes: 3
- Num of CPU: 2
- RAM: 2GB(min) per machine
- Disk: 20 GB per machine
- Kubernetes version: 1.31

## Kubernetes pre-setup
Before creating the cluster of one master and three workers be sure to edit the hosts file by adding the ip adress of all machines
For example :
```text
192.168.40.3 master
192.168.40.56 worker1
etc...
```
<br>

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

**Add the network plugin (Calico here)**

Step 1: Install the Tigera Operator and custom resources
```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml
```
<br>

Step 2: Install Calico by creating the necessary resources
```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/custom-resources.yaml
```
<br>

Step 3: Confirm that all pods are running using this command (wait until each pod has the **STATUS** of **RUNNING**)
```bash
watch kubectl get pods -n calico-system
```
<br>

Step 4: Remove the taints on the control plane so that you can schedule pods on it
```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

### On the workers node
On these nodes you just need to join the cluster by executing:
```bash
kubeadm join <control-plane-IPadd/name>:<port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

For example
```bash
sudo kubeadm join 192.168.122.195:6443 --token nx1jjq.u42y27ip3bhmj8vj --discovery-token-ca-cert-hash sha256:c6de85f6c862c0d58cc3d10fd199064ff25c4021b6e88475822d6163a25b4a6c
```

**❗IMPORTANT**
<br>
**😱😭 OH NO I CLEAR MY TERMINAL AND NOW I DON'T EVEN COPY THE JOIN COMMAND AND THE TOKEN GENERATED AT THE INIT PHASE !**

🤭 NO PANIC WE GOT YOUR BACK !!

You can get a view the available token using:
```bash
kubeadm token list
```

If the token expired you can generate a new one:
```bash
sudo kubeadm token create
```
and got a view of it 
```bash
kubeadm token list
```
An another way to generate a new token in pair with the join command is:
```bash
kubeadm token create --print-join-command
```

### Removing a worker node from the cluster
To remove a worker node from an existing cluster you have first to:

**Step 1:** Migrate the pods from the node
```bash
kubectl drain  <node-name> --delete-local-data --ignore-daemonsets
```
<br>

**Step 2:** Prevent a node from scheduling news pods use (mark it as unschedulable)
```bash
kubectl cordon <node-name>
```

<br>

**Step 3:** Revert changes made to the node since the join comand
```bash
sudo kubeadm reset
sudo rm -rf $HOME/.kube
```

<br>

Once the reset command has been executed successfully you can re-join the worker-node/new-node to the cluster.

