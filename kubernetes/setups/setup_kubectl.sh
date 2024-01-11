#!/bin/bash

# Set CLusterName
SYSTEM_NAME=template
ENV_TYPE=dev
CLUSTER_NAME=${SYSTEM_NAME}-${ENV_TYPE}-eks-cluster

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

# Update kubeconfig
update_kubeconfig() {
    CLUSTER_NAME=$1
    REGION_NAME=$2

    aws eks update-kubeconfig \
        --name ${CLUSTER_NAME} \
        --region ${REGION_NAME}

}

#####################################
# Select Region for Operation
#####################################
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_CAPETOWN}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_HONGKONG}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_TOKYO}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_SEOUL}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_OSAKA}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_MUMBAI}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_HYDERABAD}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_SINGAPORE}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_SYDNEY}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_JAKARTA}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_MELBOURNE}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_CENTRAL}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_CALGARY}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_FRANKFURT}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_ZURICH}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_STOCKHOLM}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_MILAN}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_SPAIN}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_IRELAND}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_LONDON}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_PARIS}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_TELAVIV}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_UAE}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_BAHRAIN}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_SAOPAULO}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_VIRGINIA}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_OHIO}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_CALIFORNIA}
# update_kubeconfig ${CLUSTER_NAME} ${REGION_NAME_OREGON}

exit 0
