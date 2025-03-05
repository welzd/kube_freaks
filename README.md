# 🚀 Bienvenue dans l'univers **DevSecOps sur Kubernetes** 🛡️☸️





![image](https://github.com/user-attachments/assets/df8ccf28-7302-49e3-91a0-dd279cffb681)



# Kube_freaks
This guide is intended to help you setup quickly a Kubernetes cluster.

**Description of the cluster**
OS: Ubuntu 22.04
Master node: 1
Workers nodes: 3
Num of CPU: 2
RAM: 2GB per machine
Disk: 100 GB per machine
Kubernetes version: 1.31

## Kubernetes pre-setup
Before creating the cluster be sure to use the script ....

# 🚀 Plugins et Outils Populaires pour un Cluster Kubernetes  

Pour la création et la gestion d’un cluster Kubernetes, plusieurs plugins et outils sont couramment utilisés pour améliorer la **mise en réseau**, la **sécurité**, le **stockage**, l’**observabilité** et la **gestion des workloads**.  

---

## 🌐 Mise en Réseau  
- 🔗 **CNI (Container Network Interface)** : Standard pour gérer la mise en réseau dans Kubernetes.  
- 🐆 **Calico** : Fournit le réseau et des politiques de sécurité (Network Policies).  
- 🏗️ **Flannel** : Simple et efficace pour la communication entre pods.  
- 🛡️ **Cilium** : Basé sur eBPF pour une sécurité et une observabilité avancées.  

---

## 🔒 Sécurité  
- 📜 **Kyverno** / 🏛️ **OPA (Open Policy Agent)** : Implémentation de politiques de sécurité.  
- 👀 **Falco** : Détection des comportements malveillants au sein des containers.  
- 🔍 **Trivy** : Scanner de vulnérabilités pour les images Docker et Kubernetes.  

---

## 💾 Stockage  
- 🏗️ **Rook** : Implémente Ceph pour le stockage persistant dans Kubernetes.  
- 🐴 **Longhorn** : Solution de stockage distribuée par Rancher.  
- 📦 **OpenEBS** : Fournit du stockage persistant sur des disques locaux.  

---

## 📊 Observabilité & Monitoring  
- 📈 **Prometheus** : Monitoring et métriques pour Kubernetes.  
- 📊 **Grafana** : Visualisation des métriques Prometheus.  
- 📝 **Loki** : Logging scalable (alternative à Elasticsearch).  
- 🔍 **ELK (Elasticsearch, Logstash, Kibana)** : Stack complète pour la gestion des logs.  

---

## ⚙️ Gestion des Workloads & Orchestration  
- 📦 **Helm** : Gestionnaire de paquets pour déployer des applications Kubernetes.  
- 🛠️ **Kustomize** : Outil natif pour la gestion des configurations Kubernetes.  
- 🚀 **ArgoCD** : Implémente le GitOps pour la gestion des déploiements.  

---

## 📈 Autoscaling & Load Balancing  
- 📏 **Metrics Server** : Requis pour l’Horizontal Pod Autoscaler (HPA).  
- ⚡ **KEDA** : Permet un scaling basé sur des événements (ex: messages Kafka).  
- 🌐 **Ingress-NGINX** : Contrôleur Ingress pour le routage HTTP/HTTPS.  
- 🏗️ **MetalLB** : Load Balancer pour les clusters bare-metal.  

---

## 🛠️ Outils de Gestion Kubernetes  
- ☸️ **OpenShift** : Distribution Kubernetes orientée entreprise par Red Hat.  
- 🏗️ **Rancher** : Plateforme complète pour la gestion de clusters Kubernetes multi-cloud.  
- 🌍 **K3s** : Version légère de Kubernetes optimisée pour l’Edge Computing.  
- 🔄 **Kind** : Outil pour exécuter Kubernetes en local à l’aide de containers Docker.  
- 🚀 **Minikube** : Facilite l’exécution de Kubernetes sur une machine locale.  

---

💡 *Si tu travailles sur un cluster spécifique (on-premise, cloud, edge), adapte cette liste à tes besoins !* 🚀  
