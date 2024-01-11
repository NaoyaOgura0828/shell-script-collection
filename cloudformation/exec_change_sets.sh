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

exec_change_set() {
    SYSTEM_NAME=$1
    ENV_TYPE=$2
    REGION_NAME=$3
    SERVICE_NAME=$4

    echo "------------------------------------------------------------------------------------------------------------------------------------------------------"
    echo "Change set: Create ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set ."

    aws cloudformation create-change-set \
        --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME} \
        --change-set-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set \
        --template-body file://./templates/${SERVICE_NAME}/${SERVICE_NAME}.yml \
        --cli-input-json file://./templates/${SERVICE_NAME}/${ENV_TYPE}-${REGION_NAME}-parameters.json \
        --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME}

    aws cloudformation wait change-set-create-complete \
        --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME} \
        --change-set-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set \
        --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME}

    CHANGE_SET_STATUS=$(aws cloudformation describe-change-set \
        --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME} \
        --change-set-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set \
        --query 'Status' \
        --output text \
        --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME})

    if [ "$CHANGE_SET_STATUS" = "FAILED" ]; then
        echo "Failed to create Change set."
        echo "Change set: Delete ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set ."

        aws cloudformation delete-change-set \
            --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME} \
            --change-set-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set \
            --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME}

        echo "Change set: Deleted ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set ."
        return 1
    fi

    DESCRIBE_CHANGE_SET=$(aws cloudformation describe-change-set \
        --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME} \
        --change-set-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set \
        --query 'Changes[*].[ResourceChange.Action, ResourceChange.LogicalResourceId, ResourceChange.PhysicalResourceId, ResourceChange.ResourceType, ResourceChange.Replacement]' \
        --output json \
        --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME})

    echo "Change set: ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set"
    echo "$DESCRIBE_CHANGE_SET" | jq -r '.[] | "--------------------------------------------------\nAction: \(.[0])\nLogical ID: \(.[1])\nPhysical ID: \(.[2])\nResourceType: \(.[3])\nReplacement: \(.[4])"'
    echo "--------------------------------------------------"

    read -p "Change set: Are you sure you want to run ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set ? (Y/n) " yn

    case ${yn} in
    [yY])
        echo "Execute Change set."

        aws cloudformation execute-change-set \
            --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME} \
            --change-set-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set \
            --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME}

        aws cloudformation wait stack-update-complete \
            --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME} \
            --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME}

        echo "${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME} Update completed."
        ;;
    *)

        echo "Execution of the Change set was cancelled."

        aws cloudformation delete-change-set \
            --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME} \
            --change-set-name ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set \
            --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME}

        echo "Change set: Deleted ${SYSTEM_NAME}-${ENV_TYPE}-${SERVICE_NAME}-change-set ."

        ;;
    esac

}

#####################################
# Resources to be modify
#####################################
# exec_change_set ${SYSTEM_NAME_TEMPLATE} ${ENV_TYPE_DEV} ${REGION_NAME_TOKYO} iam

exit 0
