# Kubeflow cluster integration (LTS 1.9.1)

**Prerequisities:**
- Kubernetes v1.31 cluster with one master and at least 3 workers nodes
- Kustomize for customize raw, template-free YAML files for multiple purposes, leaving the original YAML untouched and usable as it was.
- Sufficient stockage on each worker node managed by Ceph Storage (OSD)
- A good and speedy internet

Kubeflow can be installed as a standalone platform or as separated components depending on your usage.

First let's find out the right version of Kustomize embedded in recent version of kubectl
```bash
kubectl version --client
# You should see something like that
Client Version: v1.31.0
Kustomize Version: v5.4.2
```

Here is a match of the kubectl and kustomize versions  


| Kubectl version |	Kustomize version |
| :-------------: | :---------------: |
|  < v1.14 	   |    n/a |
| v1.14-v1.20 | 	v2.0.3 |
| v1.21 |	v4.0.5 |
| v1.22 |	v4.2.0 |
| v1.23 |	v4.4.1 |
| v1.24 |	v4.5.4 |
| v1.25 |	v4.5.7 |
| v1.26 |	v4.5.7 |
| v1.27 |	v5.0.1 |


### Install Kustomize
This script from the official repo detect the OS and downloads the appropriate kustomize binary to your current working directory
```
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
```

<br>

**Important:** Move the kustomize binary to the /usr/bin/ directory
```bash
sudo mv kustomize /usr/bin/
```


## Initiating a Kubeflow instance (one-liner command)
```bash
while ! kustomize build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 20; done
```

After installation, it will take some time for all Pods to become ready.  

Make sure all Pods are ready before trying to connect, otherwise you might get unexpected errors.  

To check that all Kubeflow-related Pods are ready, use the following commands:  
```bash
kubectl get pods -n cert-manager
kubectl get pods -n istio-system
kubectl get pods -n auth
kubectl get pods -n knative-eventing
kubectl get pods -n knative-serving
kubectl get pods -n kubeflow
kubectl get pods -n kubeflow-user-example-com
```

**Port forward**  

The default way of accessing Kubeflow is via port-forward.  

This enables you to get started quickly without imposing any requirements on your environment.  

Run the following to port-forward Istio's Ingress-Gateway to local port 8080:

```bash
kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80
```

After running the command, you can access the Kubeflow Central Dashboard by doing the following:  

- Open your browser and visit http://localhost:8080. You should get the Dex login screen.
- Login with the default user's credentials. The default email address is user@example.com and the default password is 12341234.

**TO-DO:** Add a section for changing default credentials.
