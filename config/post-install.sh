#!/bin/bash

#################################
# Global settings
CONFIG_DIR=/var/tmp/vagrant/config
#################################

#############
# Functions #
#############
function sourceFile()
{
  FILEPATH=$1
  echo "-----"
  echo "Executing: ${FILEPATH}"

  if [ -e ${FILEPATH} ] ; then
    source ${FILEPATH}
  else
    echo "Error: cannot find ${FILEPATH}. Skipping..."
  fi;
}

function configureProxy()
{
  FILEPATH="${CONFIG_DIR}/proxy_settings_apply.sh"
  sourceFile ${FILEPATH}
}

function fixSlowSSH()
{
  FILEPATH="${CONFIG_DIR}/fixSlowSSH.sh"
  sourceFile ${FILEPATH}
}

function speedupGrub2Boot()
{
  FILEPATH="${CONFIG_DIR}/speedupGrub2Boot.sh"
  sourceFile ${FILEPATH}
}

function updatePackages()
{
  FILEPATH="${CONFIG_DIR}/update_packages.sh"
  sourceFile ${FILEPATH}
}

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
configureProxy

# perform a silent upgrade of the system
updatePackages

fixSlowSSH

speedupGrub2Boot

# clean up
cleanUpProvisionConfig

echo "-----"
