# How to setup two-tier application deployment on kubernetes cluster
## First setup kubernetes kubeadm/minikube cluster

## SetUp

-
```bash
cd two-tier-flask-app/k8s
```
- Now, execute below commands one by one
```bash
kubectl apply -f mysql-pv.yml
kubectl apply -f mysql-pvc.yml
```
```bash
kubectl apply -f mysql-deployment.yml
```
```bash
kubectl apply -f mysql-svc.yml
```
we must create a table in mysql pod before run two-tier-app(flaskapp) manifest file
#  Run the following command after deploying mysql
```bash
kubectl exec <mysql-pod-name> -c mysql -it -- bash
mysql -u root -p
** password=admin ** 
show databases;
use mydb;
show tables;
CREATE TABLE messages (id INT AUTO_INCREMENT PRIMARY KEY, message TEXT);
```
# Then Run the flask-application
```bash
kubectl apply -f two-tier-app-deployment.yml
```
```bash
kubectl apply -f two-tier-app-svc.yml
```
