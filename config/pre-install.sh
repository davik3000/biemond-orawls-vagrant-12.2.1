#!/bin/bash

#################################
# Global settings
CONFIG_DIR=/var/tmp/vagrant/config
#################################

#############
# Functions #
#############
function cleanUpProvisionConfig()
{
    echo "-----"
    echo "Removing provision configuration folder..."
    rm -rf ${CONFIG_DIR}
    
    if [ $? -eq 0 ] ; then
      echo "-----"
      echo "Provision configuration removed."
    else
      echo "-----"
      echo "Error: Cannot remove temporary folder for provision! You should do it manually!"
    fi;
}

########
# Main #
########

# clean up
cleanUpProvisionConfig

echo "-----"
