#!/bin/bash
echo "-----"
echo "puppet configuration"
echo " > link 'hiera.yaml' from shared folder"
ln -sf /var/tmp/vagrant/puppet/hiera.yaml /etc/puppetlabs/code/hiera.yaml
echo " > remove 'modules' folder from guest /etc/puppetlabs"
rm -rf /etc/puppetlabs/code/modules
echo " > link 'modules' folder from shared folder"
ln -sf /var/tmp/vagrant/puppet/environments/development/modules /etc/puppetlabs/code/modules
echo "-----"