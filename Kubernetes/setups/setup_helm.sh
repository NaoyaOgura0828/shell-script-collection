#!/bin/bash

# Set EKS CLuster Name
SYSTEM_NAME=template
ENV_TYPE=dev
CLUSTER_NAME=${SYSTEM_NAME}-${ENV_TYPE}-eks-cluster # Optional REPLACE_ME

# Set VPC Name
VPC_NAME=${SYSTEM_NAME}-${ENV_TYPE}-vpc # Optional REPLACE_ME
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${VPC_NAME}" --query "Vpcs[].VpcId" --output text)

# Set AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Region List
REGION_NAME_CAPETOWN=af-south-1
REGION_NAME_HONGKONG=ap-east-1
REGION_NAME_TOKYO=ap-northeast-1
REGION_NAME_SEOUL=ap-northeast-2
REGION_NAME_OSAKA=ap-northeast-3
REGION_NAME_MUMBAI=ap-south-1
REGION_NAME_HYDERABAD=ap-south-2
REGION_NAME_SINGAPORE=ap-southeast-1
REGION_NAME_SYDNEY=ap-southeast-2
REGION_NAME_JAKARTA=ap-southeast-3
REGION_NAME_MELBOURNE=ap-southeast-4
REGION_NAME_CENTRAL=ca-central-1
REGION_NAME_CALGARY=ca-west-1
REGION_NAME_FRANKFURT=eu-central-1
REGION_NAME_ZURICH=eu-central-2
REGION_NAME_STOCKHOLM=eu-north-1
REGION_NAME_MILAN=eu-south-1
REGION_NAME_SPAIN=eu-south-2
REGION_NAME_IRELAND=eu-west-1
REGION_NAME_LONDON=eu-west-2
REGION_NAME_PARIS=eu-west-3
REGION_NAME_TELAVIV=il-central-1
REGION_NAME_UAE=me-central-1
REGION_NAME_BAHRAIN=me-south-1
REGION_NAME_SAOPAULO=sa-east-1
REGION_NAME_VIRGINIA=us-east-1
REGION_NAME_OHIO=us-east-2
REGION_NAME_CALIFORNIA=us-west-1
REGION_NAME_OREGON=us-west-2

# Associate an IAM OIDC provider with the EKS cluster
eksctl utils associate-iam-oidc-provider \
    --cluster=${CLUSTER_NAME} \
    --approve \
    --region=${REGION_NAME_TOKYO} # Optional REPLACE_ME

# Get iam_policy.json
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json

# Create IAM Policy
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json > /dev/null

# Create IAM Role and Kubernetes ServiceAccount
eksctl create iamserviceaccount \
  --cluster=template-dev-eks-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn="arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy" \
  --approve

# Deploy aws-load-balancer-controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
    -n kube-system \
    --set clusterName=${CLUSTER_NAME} \
    --set serviceAccount.create=false \
    --set serviceAccount.name=aws-load-balancer-controller \
    --set vpcId=${VPC_ID} \
    --set region=${REGION_NAME_TOKYO} # Optional REPLACE_ME

# Add the EKS chart repository
helm repo add eks https://aws.github.io/eks-charts

# Update the EKS chart repository
helm repo update eks

# Remove iam_policy.json
rm iam_policy.json

exit 0
