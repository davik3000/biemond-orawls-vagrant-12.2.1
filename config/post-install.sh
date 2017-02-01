#!/bin/bash

#################################
# Global settings
CONFIG_DIR=
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
    source ${FILEPATH} "${CONFIG_DIR}"
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

function execute()
{
  if [ -d ${CONFIG_DIR} ] ; then
    configureProxy

    # perform a silent upgrade of the system
    updatePackages

    fixSlowSSH
    
    speedupGrub2Boot
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

execute

echo "-----"
