#!/bin/bash

#################################
# Global settings
SHARED_PUPPET_DIR=
#################################

#############
# Functions #
#############
function configurePuppet()
{
  echo "-----"
  echo "Configuring puppet"

  echo " > link 'hiera.yaml' from shared folder"
  ln -sf ${SHARED_PUPPET_DIR}/hiera.yaml /etc/puppetlabs/code/hiera.yaml

  echo " > remove 'modules' folder from guest /etc/puppetlabs"
  rm -rf /etc/puppetlabs/code/modules

  echo " > link 'modules' folder from shared folder"
  ln -sf ${SHARED_PUPPET_DIR}/environments/development/modules /etc/puppetlabs/code/modules
}

########
# Main #
########

# use argument for config folder path
if [ -n $1 ] ; then
  SHARED_PUPPET_DIR=$1
fi;

configurePuppet

echo "-----"
