
# Terminal Command History for Two-Tier-application deploy on Kind-cluster

## 1. Creating and Managing Kubernetes Cluster with Kind

- Clear terminal:
  ```bash
  clear
  ```
- Inspect the repository and read the config.yml manifest for creating kind-cluster(Kubernetes in docker)
  
- Create a 3-node Kubernetes cluster using Kind:
  ```bash
  kind create cluster --config=config.yml --name=k8s-cluster
  ```

- Check cluster information:
  ```bash
  kubectl cluster-info --context kind-kind
  kubectl get nodes
  kind get clusters
  ```

---

## 2. Installing kubectl

- Download `kubectl` for managing Kubernetes clusters:
  ```bash
  curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin
  kubectl version --short --client
  ```

---

## 3. Managing Docker and Kubernetes Pods

- Check Docker containers running:
  ```bash
  docker ps
  ```

- List all Kubernetes pods in all namespaces:
  ```bash
  kubectl get pods -A
  ```

---

## 4. Cloning and Running the Two-tier-application

- Clone the voting app repository:
  ```bash
  git clone https://github.com/jbn1995/Two-Tier-Application.git
  cd k8s-manifests/
  ```

- Apply Kubernetes YAML specifications for the Two-tier-app:
  ```bash
  kubectl apply -f k8s-manifests/
  ```
- Run the mysql query after deployment of mysql pod
  ```bash
  kubectl exec <mysql-pod-name> -c mysql -it -- bash
  mysql -u root -p
  ** password=admin ** 
  show databases;
  use mydb;
  show tables;
  CREATE TABLE messages (id INT AUTO_INCREMENT PRIMARY KEY, message TEXT);
  ```

- Change the MYSQL_HOST ip in deployment file of flaskapp (name-two-tier-app-deployment.yaml)
  ```bash
  spec:
      containers:
        - name: two-tier-app
          image: jabin95/flaskapp:04
          env:
            - name: MYSQL_HOST
              value: "10.96.174.75"          # this is your mysql's service clusture IP, Make sure to change it with yours
           ```
  
- List all Kubernetes resources:
  ```bash
  kubectl get all
  ```

- Forward local ports for accessing the voting and result apps:
  ```bash
  kubectl port-forward service/two-tier-app-service 30050:80 --address=0.0.0.0 &
```
## 6. Installing Argo CD

- Create a namespace for Argo CD:
  ```bash
  kubectl create namespace argocd
  ```

- Apply the Argo CD manifest:
  ```bash
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  ```

- Check services in Argo CD namespace:
  ```bash
  kubectl get svc -n argocd
  ```

- Expose Argo CD server using NodePort:
  ```bash
  kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
  ```

- Forward ports to access Argo CD server:
  ```bash
  kubectl port-forward -n argocd service/argocd-server 8443:443 &
  ```
---
---

## 9. Argo CD Initial Admin Password

- Retrieve Argo CD admin password:
  ```bash
  kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
  ```
---

## 7. Deleting Kubernetes Cluster

- Delete the Kind cluster:
  ```bash
  kind delete cluster --name=kind
  ```

---

## 8. Installing Kubernetes Dashboard

- Deploy Kubernetes dashboard:
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
  ```

- Create a token for dashboard access:
  ```bash
  kubectl -n kubernetes-dashboard create token admin-user
  ```



## 10. Install HELM

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

---

## 11. Install Kube Prometheus Stack

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
kubectl create namespace monitoring
helm install kind-prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --set prometheus.service.nodePort=30000 --set prometheus.service.type=NodePort --set grafana.service.nodePort=31000 --set grafana.service.type=NodePort --set alertmanager.service.nodePort=32000 --set alertmanager.service.type=NodePort --set prometheus-node-exporter.service.nodePort=32001 --set prometheus-node-exporter.service.type=NodePort
kubectl get svc -n monitoring
kubectl get namespace
```

---

```bash
kubectl port-forward svc/kind-prometheus-kube-prome-prometheus -n monitoring 32100:9090 --address=0.0.0.0 &
kubectl port-forward svc/kind-prometheus-grafana -n monitoring 31000:80 --address=0.0.0.0 &

kubectl get secret --namespace monitoring kind-prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

```


---

## 12. Prometheus Queries

```bash
sum (rate (container_cpu_usage_seconds_total{namespace="default"}[1m])) / sum (machine_cpu_cores) * 100

sum (container_memory_usage_bytes{namespace="default"}) by (pod)


sum(rate(container_network_receive_bytes_total{namespace="default"}[5m])) by (pod)
sum(rate(container_network_transmit_bytes_total{namespace="default"}[5m])) by (pod)

```
## 12. Uninstall prometheus&Grafana
```bash
helm uninstall kind-prometheus --namespace monitoring


```

---



