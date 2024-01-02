#!/bin/bash

# Update resource
update_resource() {
    RESOURCE_NAME=$1

    helm upgrade ${RESOURCE_NAME} ./helm_charts/${RESOURCE_NAME}

}

##############################
# Select resources to update
##############################
# update_resource nginx

exit 0
