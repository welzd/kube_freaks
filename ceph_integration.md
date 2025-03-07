# Rook-Ceph cluster integration

## Prerequisities
- Kubernetes v1.17 or above
- Raw devices (no partitions or formatted filesystems) ->  query lvm2 to be install on the machine
- Raw partitions (no formatted filesystem)
- Persistent Volumes available from a storage class in block mode

We will be using only raw partitions/devices to work with:
Make sure to add at least 100GB raw disk to each node (Kubeflow installation prevention)

### The rook operator
As documented on the Ceph Docs you can deploy the rook operator 
```bash
git clone --single-branch --branch v1.9.2 https://github.com/rook/rook.git
cd deploy/examples
kubectl create -f crds.yaml -f common.yaml -f operator.yaml
```
<br>

Verify the rook-ceph-operator is in the `Running` state before proceeding
```bash
kubectl -n rook-ceph get pod
```


### Ceph cluster
Now that the Rook operator is running we can create the Ceph cluster

