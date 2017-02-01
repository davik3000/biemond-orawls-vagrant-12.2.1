#!/bin/bash

#################################
# Global settings
CONFIG_DIR=
#################################

#############
# Functions #
#############
function cleanUpProvisionConfig()
{
  echo "-----"
  echo "Removing provision configuration folder"

  if [ -d ${CONFIG_DIR} ] ; then
    echo " > removing folder: ${CONFIG_DIR}"
    rm -rf ${CONFIG_DIR}
    if [ $? -eq 0 ] ; then
       echo "-----"
       echo "Provision configuration removed."
    else
       echo "-----"
       echo "Error: Cannot remove temporary folder for provision! You should do it manually!"
    fi;
  else
    echo "-----"
    echo "Error: folder ${CONFIG_DIR} doesn't not exist!"
  fi; 
}

########
# Main #
########

# use argument for config folder path
if [ -n $1 ] ; then
  CONFIG_DIR=$1
fi;

# clean up
cleanUpProvisionConfig

echo "-----"
