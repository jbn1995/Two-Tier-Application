# Two-tier Application Deployment on AWS EKS

This guide will walk you through deploying a two-tier application on AWS EKS.

## Prerequisites

- AWS account
- Terraform
- AWS CLI
## IAM Setup

1. **Create an IAM User:**
   - Create a user named `eks-admin` with `AdministratorAccess`.
   - Generate Security Credentials (Access Key and Secret Access Key).

2. ** EKS Setup **

** AWS EKS Cluster Deployment with Terraform **

This repository contains the necessary Terraform code to deploy an EKS cluster on AWS, including IAM roles, policies, and EKS node groups.

## Prerequisites

```bash
cd terraform-eks
```
Before you begin, ensure you have the following tools installed:
- **Terraform** ([Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli))
- **AWS CLI** ([Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html))
- **kubectl** ([Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/))

### AWS Credentials

Make sure your AWS credentials are configured properly:
```bash
aws configure
```
## Resources Created by this Terraform Code

    IAM Roles for both the EKS cluster and EKS node groups, along with the necessary policy attachments.
    EKS Cluster with the default VPC and subnets.
    EKS Node Group with auto-scaling configurations.

# Terraform Resources
** IAM Roles **

    EKS Cluster Role: Allows the EKS cluster to assume the necessary permissions.
    Node Group Role: Allows EC2 instances to function as worker nodes in the EKS cluster.

## EKS Cluster

# The EKS cluster is created in the default VPC and attached to subnets using the following configuration:

```bash
resource "aws_eks_cluster" "main" {
  name     = "EKS_cluster"
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = data.aws_subnets.public.ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy
  ]
}
```
# EKS Node Group

# The node group is created with a desired size of 1 and can scale up to 2 instances:
```bash
resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "node-cloud"
  node_role_arn   = aws_iam_role.ex1.arn

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t3.micro"]

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}
```
## Outputs

**After deploying the infrastructure, the following outputs are generated: **

    Cluster Endpoint: The endpoint URL for the EKS cluster.
    Certificate Authority Data: The certificate data needed to authenticate kubectl commands.

3. **Usage**
# Initialize Terraform

# First, initialize the Terraform project:

```bash

terraform init
```
** Apply the Terraform Plan **

Apply the plan to provision the EKS cluster:

```bash

terraform apply
```
# Notes
```
    The code uses the default VPC. Ensure that the default VPC exists in your AWS account, or modify the VPC configuration accordingly.
    The worker nodes are of type t3.micro to minimize cost. You can modify the instance type based on your workload.
```
4. **Install kubectl:**
```bash
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```
# update Kubeconfig

**EKS Cluster Access from terminal**
```bash

aws eks --region ap-south-1  update-kubeconfig --name EKS_cluster
```

** Verify the nodes: **
```bash
kubectl get nodes
kubectl config view
```
# Deploy the Eks manifest file now

5. **Clean Up**

## To destroy the created EKS infrastructureon AWS:

```bash

terraform destroy
```
