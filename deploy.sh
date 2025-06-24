#!/bin/bash

set -e

### CONFIG ###
KUBECONFIG_FILE="$HOME/.kube/config"
TERRAFORM_DIR="./terraform"
ANSIBLE_DIR="./nginx-deployment/ansible"
ANSIBLE_PLAYBOOK="${ANSIBLE_DIR}/deploy-nginx.yml"
ANSIBLE_INVENTORY="${ANSIBLE_DIR}/inventory"

echo "Step 1: Initializing Terraform..."
cd "$TERRAFORM_DIR"
terraform init

echo "Step 2: Applying Terraform to provision EKS and network..."
terraform apply -auto-approve

echo "Step 3: Exporting kubeconfig..."
aws eks update-kubeconfig --name eks-cluster --region ap-south-1

echo "Step 4: Deploying Nginx with Ansible..."
cd ..
ansible-playbook -i "$ANSIBLE_INVENTORY" "$ANSIBLE_PLAYBOOK" --extra-vars "kubeconfig_path=$KUBECONFIG_FILE"

echo "Deployment Complete!"
