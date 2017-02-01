#!/bin/bash
echo "-----"
echo "puppet configuration"
ln -sf /var/tmp/puppet/hiera.yaml /etc/puppetlabs/code/hiera.yaml
rm -rf /etc/puppetlabs/code/modules
ln -sf /var/tmp/puppet/environments/development/modules /etc/puppetlabs/code/modules