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

replace_parameter_json() {
    ENV_TYPE=$1
    REGION_NAME=$2
    REPLACE_KEY_NAME=$3
    SOURCE_SERVICE_NAME=$4
    TARGET_SERVICE_NAME=$5

    replace_value=$(jq -r '.Parameters[] | select(.ParameterKey == "'${REPLACE_KEY_NAME}'").ParameterValue' "./templates/${SOURCE_SERVICE_NAME}/${ENV_TYPE}-${REGION_NAME}-parameters.json")

    jq --indent 4 '.Parameters[] |= if .ParameterKey == "'${REPLACE_KEY_NAME}'" then .ParameterValue = "'${replace_value}'" else . end' \
        ./templates/${TARGET_SERVICE_NAME}/${ENV_TYPE}-${REGION_NAME}-parameters.json > \
        tmp.json && mv tmp.json ./templates/${TARGET_SERVICE_NAME}/${ENV_TYPE}-${REGION_NAME}-parameters.json

}

#####################################
# Resources to be built
#####################################
# replace_parameter_json ${ENV_TYPE_DEV} ${REGION_NAME_TOKYO} KeyName keypair ec2-bastion

exit 0
