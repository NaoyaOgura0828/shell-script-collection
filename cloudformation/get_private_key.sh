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

get_private_key() {
    SYSTEM_NAME=$1
    ENV_TYPE=$2
    REGION_NAME=$3

    key_pair_name=$(jq -r '.Parameters[] | select(.ParameterKey == "KeyName").ParameterValue' "./templates/keypair/${ENV_TYPE}-${REGION_NAME}-parameters.json")

    AWS_ACCOUNT_ID=$(aws sts get-caller-identity \
        --query "Account" \
        --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME} \
        --output text)

    KEY_PAIR_ID=$(aws ec2 describe-key-pairs \
        --filters Name=key-name,Values=${key_pair_name} \
        --query KeyPairs[*].KeyPairId \
        --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME} \
        --output text)

    aws ssm get-parameter \
        --name /ec2/keypair/${KEY_PAIR_ID} \
        --with-decryption \
        --query Parameter.Value \
        --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME} \
        --output text > ${key_pair_name}.pem

    chmod 600 ${key_pair_name}.pem

}

#####################################
# Resources to be built
#####################################
# get_private_key ${SYSTEM_NAME_TEMPLATE} ${ENV_TYPE_DEV} ${REGION_NAME_TOKYO}

exit 0
