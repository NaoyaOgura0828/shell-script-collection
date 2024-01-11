#!/bin/bash

cd $(dirname $0)

# Definition of each SystemName
SYSTEM_NAME_TEMPLATE=template

# Definition of each EnvType
ENV_TYPE_DEV=dev
ENV_TYPE_STG=stg
ENV_TYPE_PROD=prod

# Definition of each RegionName
REGION_NAME_TOKYO=tokyo
REGION_NAME_OSAKA=osaka
REGION_NAME_VIRGINIA=virginia

echo "------------------------------------------------------------------------------------------------------------------------------------------------------"
read -p "Delete all resources selected for deletion. Are you sure you want to do this? (Y/n) " yn

case ${yn} in
[yY])
    echo 'Start deletion.'

    delete_stack() {
        SYSTEM_NAME=$1
        ENV_TYPE=$2
        REGION_NAME=$3
        SERVICE_NAME=$4

        aws cloudformation delete-stack \
            --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME} \
            --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME}

        aws cloudformation wait stack-delete-complete \
            --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME} \
            --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME}
    }

    #####################################
    # Resources to be delete
    #####################################
    # delete_stack ${SYSTEM_NAME_TEMPLATE} ${ENV_TYPE_DEV} ${REGION_NAME_TOKYO} iam

    echo 'Deletion completed.'
    ;;
*)
    # 中止
    echo 'Cancelled.'
    ;;
esac

exit 0
