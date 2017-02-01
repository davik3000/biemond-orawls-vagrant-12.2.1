#!/bin/bash
echo "-----"
echo "puppet installation"

# DART probably not needed
#echo " > importing RPM GPG key for puppetlabs"
#rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs

echo " > install/update repository for puppetlabs"
rpm -Uh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

echo " > install puppet"
yum -q -y install puppet
