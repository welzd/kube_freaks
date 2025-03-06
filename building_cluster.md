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
