#!/bin/bash

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

function updatePackages_installPrereqs()
{
    yum -q -y install \
        yum-utils
}

function updatePackages_setConfigManager()
{
    # yum-config-manager is contained in the package "yum-utils"
    yum-config-manager -q --save --setopt=ies.skip_if_unavailable=true > /dev/null
}
function updatePackages_yumUpdate()
{
    yum -q makecache fast
    yum -q -y update
}
function updatePackages_enableSoftwareCollectionsRepos()
{
    yum -q -y install \
        centos-release-scl \
        scl-utils-build
}
function updatePackages_installUtils()
{
    yum -q -y install \
        man \
        openssh-clients \
        git \
        subversion \
        vim \
        unzip \
        bzip2 \
        curl \
        wget \
        net-tools \
        nmap \
        ntp \
        telnet \
        gcc \
        dos2unix
}
function updatePackages()
{
    echo "-----"
    echo "Updating packages"

    updatePackages_installPrereqs
    updatePackages_setConfigManager

    echo " > executing yum update"
    updatePackages_yumUpdate

    echo " > enabling Software Collections Repository"
    updatePackages_enableSoftwareCollectionsRepos

    echo " > installing utilities"
    updatePackages_installUtils
    
    if [ $? -eq 0 ] ; then
      echo "-----"
      echo "Packages update completed"
    else
      echo "-----"
      echo "Error: packages update failed"
    fi;
}

function cleanUpProvisionConfig()
{
    echo "-----"
    echo "Removing temporary folder for provision configuration"
    rm -rf ${CONFIG_DIR}
    
    if [ $? -eq 0 ] ; then
      echo "-----"
      echo "Completed."
    else
      echo "-----"
      echo "Error: Cannot remove temporary folder"
    fi;
}

########
# Main #
########
fixSlowSSH

echo "-----"
