#!/bin/bash

#################################
# Global settings

#################################

#############
# Functions #
#############
function speedupGrub2Boot()
{
    echo "-----"
    echo "Speeding up grub2 boot time"

    GRUB2_CONFIG_PATH=/etc/default/grub
    REGEXP_TIMEOUT='^.?GRUB_TIMEOUT.*$'
    GRUBTIMEOUT_1='GRUB_TIMEOUT=1'
    # -E use extended regexp, -q quiet
    grep -Eq ${REGEXP_TIMEOUT} ${GRUB2_CONFIG_PATH}

    if [ $? -eq 0 ] ; then
        # found, fixing with sed
        # -r use extended regexp, -i edit in-place
        sed -ri "s/${REGEXP_TIMEOUT}/${GRUBTIMEOUT_1}/g" ${GRUB2_CONFIG_PATH}
    else
        # not found, append it with cat
        echo ${GRUBTIMEOUT_1} >> ${GRUB2_CONFIG_PATH}
    fi;

    # apply configuration
    grub2-mkconfig -o /boot/grub2/grub.cfg
}

########
# Main #
########
speedupGrub2Boot

echo "-----"
