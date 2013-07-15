#!/bin/bash

UNIT_NAME=$(echo $JUJU_UNIT_NAME | cut -d/ -f1)
UNIT_DIR=/srv/${UNIT_NAME}

DJANGO_APP_PAYLOAD=$(config-get seg_payload)
INSTANCE_TYPE=$(config-get instance_type)

USER_CODE_RUNNER=$(config-get user_code_runner)
GROUP_CODE_RUNNER=$(config-get group_code_runner)
USER_CODE_OWNER=$(config-get user_code_owner)
GROUP_CODE_OWNER=$(config-get group_code_owner)


function ctrl_service {
    # Check if there is an upstart or sysvinit service defined and issue the
    # requested command if there is. This is used to control services in a
    # friendly way when errexit is on.
    service_name=$1
    service_cmd=$2
    ( service --status-all 2>1 | grep -w $service_name ) && service $service_name $service_cmd
    ( initctl list 2>1 | grep -w $service_name ) && service $service_name $service_cmd
    return 0
}
