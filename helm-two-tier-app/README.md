This repository includes Helm charts to deploy a two-tier Flask application with a MySQL backend. The charts are packaged and ready for deployment in a Kubernetes cluster.
Prerequisites

Ensure the following tools are installed and configured:

    Kubernetes cluster: A running Kubernetes cluster (local or cloud-based).
    Helm: The package manager for Kubernetes. Install Helm if it's not already installed. For installation, visit: Helm Installation Guide.
    kubectl: The Kubernetes CLI tool to interact with the cluster.

Steps to Deploy

# Clone the Repository (if you haven't already):

```bash

git clone https://github.com/jbn1995/Two-Tier-Application.git
cd Two-Tier-Application/helm-two-tier-app
```
Deploy the MySQL Database:

To install the MySQL chart from the packaged .tgz file:

```bash

helm install mysql-release ./mysql-chart-0.1.0.tgz
```
This command will deploy the MySQL database in your Kubernetes cluster with the Helm chart configuration.

# Deploy the Flask Application:

To install the Flask app chart from the packaged .tgz file:

```bash

helm install flask-app-release ./flask-app-chart-0.1.0.tgz
```
This will deploy the Flask application in your Kubernetes cluster.

# Verify the Deployments:

Check the status of the deployments:

```bash

kubectl get pods
```
Ensure that both the MySQL and Flask application pods are running without any errors.

Access the Flask Application:

If you're using a service like LoadBalancer or Ingress to expose your Flask application, follow these steps:

Check the service:

```bash

        kubectl get svc
```
Access the application:
Use the external IP or domain configured in your Ingress to access the application.

##Uninstalling the Application

To uninstall the application and clean up the resources:

# Uninstall the Flask Application:

``` bash
helm uninstall flask-app-release
```
# Uninstall the MySQL Database:

```bash
    helm uninstall mysql-release
```
## Notes

    The Helm chart configurations for both MySQL and the Flask application can be customized. You can modify the values.yaml files in their respective directories for any specific adjustments (like database credentials, replicas, etc.).

    For more information on Helm, refer to the official documentation: Helm Docs.
