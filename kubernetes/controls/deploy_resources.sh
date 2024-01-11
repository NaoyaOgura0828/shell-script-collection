#!/bin/bash

# Deploy resource
deploy_resource() {
    RESOURCE_NAME=$1

    helm install ${RESOURCE_NAME} ./helm_charts/${RESOURCE_NAME}

}

##############################
# Select resources to deploy
##############################
# deploy_resource nginx

exit 0
