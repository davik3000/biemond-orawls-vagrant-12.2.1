#!/bin/bash

#################################
# Global settings

#################################

#############
# Functions #
#############
function fixSlowSSH()
{
    echo "-----"
    echo "Fixing known problem of slow SSH connection due to DNS issues"

    SSHD_CONFIG_PATH=/etc/ssh/sshd_config
    REGEXP_USEDNS='^.?UseDNS.*$'
    USEDNS_NO='UseDNS no'
    # -E use extended regexp, -q quiet
    grep -Eq ${REGEXP_USEDNS} ${SSHD_CONFIG_PATH}

    if [ $? -eq 0 ] ; then
        # found, fixing with sed
        # -r use extended regexp, -i edit in-place
        sed -ri "s/${REGEXP_USEDNS}/${USEDNS_NO}/g" ${SSHD_CONFIG_PATH}
    else
        # not found, append it with cat
        echo ${USEDNS_NO} >> ${SSHD_CONFIG_PATH}
    fi;
}

########
# Main #
########
fixSlowSSH

echo "-----"
