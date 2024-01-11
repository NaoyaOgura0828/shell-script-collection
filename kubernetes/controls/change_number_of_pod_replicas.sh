#!/bin/bash

# Start_pod
change_number_of_pod_replica() {
    NAME_SPACE=$1
    DEPLOYMENT_NAME=$2
    REPLICAS_NUMBER=$3

    # Change number of pod replica
    kubectl scale deployment/${DEPLOYMENT_NAME} --replicas="${REPLICAS_NUMBER}" -n ${NAME_SPACE}

}

##############################################
# Select Deployment Name and Replicas Number
##############################################
# change_number_of_pod_replica default nginx 0
# change_number_of_pod_replica kube-system aws-load-balancer-controller 0
# change_number_of_pod_replica kube-system coredns 0

exit 0
