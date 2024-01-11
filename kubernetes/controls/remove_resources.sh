#!/bin/bash

# Remove resource
remove_resource() {
    RESOURCE_NAME=$1

    helm uninstall ${RESOURCE_NAME}

}

##############################
# Select resources to remove
##############################
# remove_resource nginx

exit 0
