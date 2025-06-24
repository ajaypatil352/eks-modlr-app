#!/bin/bash

set -e

echo "Fetching Load Balancer DNS names..."

PUBLIC_LB=$(kubectl get svc nginx-public -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null)
PRIVATE_LB=$(kubectl get svc nginx-private -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null)

if [[ -z "$PUBLIC_LB" ]]; then
  echo "Public Load Balancer not found (nginx-public service)."
  exit 1
fi

if [[ -z "$PRIVATE_LB" ]]; then
  echo "Private Load Balancer not found (nginx-private service)."
  exit 1
fi

echo "Public LB: https://${PUBLIC_LB}"
echo "Private LB: https://${PRIVATE_LB}"

echo "Testing Public HTTPS Endpoint..."
curl -k --max-time 10 --silent "https://${PUBLIC_LB}" | grep -q "Welcome to nginx" \
  && echo "Public HTTPS: Nginx is reachable" \
  || echo "Public HTTPS: Nginx is not reachable"

echo "Testing Private HTTPS Endpoint (requires VPC access)..."
curl -k --max-time 10 --silent "https://${PRIVATE_LB}" | grep -q "Welcome to nginx" \
  && echo "Private HTTPS: Nginx is reachable from inside the VPC" \
  || echo "Private HTTPS: Not reachable (expected if you're outside VPC)"
