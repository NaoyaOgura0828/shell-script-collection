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

    delete_record_from_bastion_domain() {
        SYSTEM_NAME=$1
        ENV_TYPE=$2
        REGION_NAME=$3

        parent_naked_domain=$(jq -r '.Parameters[] | select(.ParameterKey == "ParentNakedDomain").ParameterValue' "./templates/route53-hostzone/${ENV_TYPE}-${REGION_NAME}-parameters.json")

        bastion_domain_id=$(
            aws route53 list-hosted-zones-by-name \
                --dns-name bastion.${parent_naked_domain} \
                --query "HostedZones[0].Id" \
                --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME} \
                --output text |
                awk -F'/' '{print $3}'
        )

        bastion_public_ip=$(
            aws route53 list-resource-record-sets \
                --hosted-zone-id ${bastion_domain_id} \
                --query "ResourceRecordSets[?Type == 'A' && Name == 'bastion.${parent_naked_domain}.'].ResourceRecords[0].Value" \
                --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME} \
                --output text
        )

        aws route53 change-resource-record-sets \
            --hosted-zone-id ${bastion_domain_id} \
            --profile ${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME} \
            --change-batch \
            "{
                \"Changes\": [
                    {
                        \"Action\": \"DELETE\",
                        \"ResourceRecordSet\": {
                            \"Name\": \"bastion.${parent_naked_domain}\",
                            \"Type\": \"A\",
                            \"TTL\": 300,
                            \"ResourceRecords\": [
                                {
                                    \"Value\": \"${bastion_public_ip}\"
                                }
                            ]
                        }
                    }
                ]
            }" > /dev/null

    }

    #####################################
    # Resources to be delete
    #####################################
    # delete_record_from_bastion_domain ${SYSTEM_NAME_TEMPLATE} ${ENV_TYPE_DEV} ${REGION_NAME_TOKYO}

    echo 'Deletion completed.'
    ;;
*)
    # 中止
    echo 'Cancelled.'
    ;;
esac

exit 0
