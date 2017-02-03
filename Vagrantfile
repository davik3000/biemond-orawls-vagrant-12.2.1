# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  _shared_software_src_path="./software"
  _shared_software_dst_path="/var/tmp/vagrant/software"
  _shared_puppet_src_path="./puppet"
  _shared_puppet_dst_path="/var/tmp/vagrant/puppet"

  _provision_config_src_path="./config"
  _provision_config_dst_path="/tmp/vagrant/config"

  _provision_script_preinstall_path="./config/pre-install.sh"
  _provision_script_postinstall_path="./config/post-install.sh"

  _provision_script_puppet_install_path="./config/puppet_install.sh"
  _provision_script_puppet_config_path="./config/puppet_config.sh"

  # DART using the official CentOS box
  config.vm.box = "centos/7"

  config.vm.define "admin" , primary: true do |admin|

    # DART disabled vmware provider config
    #admin.vm.provider :vmware_fusion do |v, override|
    #  override.vm.box = "centos-7-1511-x86_64-vmware"
    #  override.vm.box_url = "https://dl.dropboxusercontent.com/s/h5g5kqjrzq5dn53/centos-7-1511-x86_64-vmware.box"
    #  #override.vm.box = "OEL7_2-x86_64-vmware"
    #  #override.vm.box_url = "https://dl.dropboxusercontent.com/s/ymr62ku2vjjdhup/OEL7_2-x86_64-vmware.box"
    #end

    admin.vm.hostname = "admin.example.com"
    # DART disable /vagrant folder because of rsync settings issues with official CentOS box
    #admin.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
    admin.vm.synced_folder ".", "/vagrant", disabled: true

    # DART check and exec only if plugin are not disabled
    if Vagrant.has_plugin?("vagrant-vbguest")
      # DART updated local folder with software installers
      admin.vm.synced_folder _shared_software_src_path, _shared_software_dst_path
      # DART added "puppet" as synced folder instead of using provision copy mechanism
      admin.vm.synced_folder _shared_puppet_src_path, _shared_puppet_dst_path
    end

    # DART private network, use vbox internal networking
    admin.vm.network :private_network, ip: "10.10.10.10", virtualbox__intnet: true

    # DART disabled vmware provider config
    #admin.vm.provider :vmware_fusion do |vb|
    #  vb.vmx["numvcpus"] = "2"
    #  vb.vmx["memsize"] = "2048"
    #end

    admin.vm.provider :virtualbox do |vb|
      # DART updated with Vagrant builtin command
      vb.memory = "2048"
      vb.name = "vagrant-orawls-admin"
      vb.cpus = 2
    end

    # DART disabled inline command, moved below into dedicated script
    #admin.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppetlabs/code/hiera.yaml;rm -rf /etc/puppetlabs/code/modules;ln -sf /vagrant/puppet/environments/development/modules /etc/puppetlabs/code/modules"

    # DART use provision to apply requirement (yum updates, fixes, puppet)
    # DART clean up config
    admin.vm.provision :shell do |s|
      s.path = _provision_script_preinstall_path
      s.args = [_provision_config_dst_path]
    end
    # DART send config
    admin.vm.provision :file do |f|
      f.source = _provision_config_src_path
      f.destination = _provision_config_dst_path
    end
    # DART apply config
    admin.vm.provision :shell do |s|
      s.path = _provision_script_postinstall_path
      s.args = [_provision_config_dst_path]
    end

    # DART install and config puppet
    admin.vm.provision :shell, path: _provision_script_puppet_install_path
    admin.vm.provision :shell do |s|
      s.path = _provision_script_puppet_config_path
      s.args = [_shared_puppet_dst_path]
    end

    # in order to enable this shared folder, execute first the following in the host machine: mkdir log_puppet_weblogic && chmod a+rwx log_puppet_weblogic
    #admin.vm.synced_folder "./log_puppet_weblogic", "/tmp/log_puppet_weblogic", :mount_options => ["dmode=777","fmode=777"]

    # DART disabled automatic provision with puppet
    #admin.vm.provision :puppet do |puppet|
    #  #puppet.environment_path = "puppet/environments"
    #  puppet.environment_path = "./puppet/environments"
    #  puppet.environment      = "development"
    #
    #  puppet.manifests_path = "./puppet/environments/development/manifests"
    #  puppet.manifest_file  = "site.pp"
    #
    #  puppet.options = [
    #    '--verbose',
    #    '--report',
    #    '--trace',
    #    #'--debug',
    #    #'--parser future',
    #    '--strict_variables',
    #    #'--hiera_config /vagrant/puppet/hiera.yaml'
    #    '--hiera_config /var/tmp/vagrant/puppet/hiera.yaml'
    #  ]
    #
    #  puppet.facter = {
    #    "environment" => "development",
    #    "vm_type"     => "vagrant",
    #  }
    #
    #end
  end

  # DART create a loop for node creation
  (1..2).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.hostname = "node#{i}.example.com"

      node.vm.synced_folder ".", "/vagrant", disabled: true

      # DART check if plugin are disabled
      if Vagrant.has_plugin?("vagrant-vbguest")
        # DART updated local folder with software installers
        #admin.vm.synced_folder "/Users/edwin/software", "/software"
        node.vm.synced_folder _shared_software_src_path, _shared_software_dst_path
        # DART added "puppet" as synced folder instead of using provision copy mechanism
        node.vm.synced_folder _shared_puppet_src_path, _shared_puppet_dst_path
      end

      # DART disabled private network, use vbox internal networking
      #admin.vm.network :private_network, ip: "10.10.10.10"
      node.vm.network :private_network, ip: "10.10.10.1#{i}", virtualbox__intnet: true

      node.vm.provider :virtualbox do |vb|
        vb.memory = "1532"
        vb.name = "vagrant-orawls-node#{i}"
        vb.cpus = 1
      end

      # DART use provision to apply requirement (yum updates, fixes, puppet)
      # DART clean up config
      node.vm.provision :shell do |s|
        s.path = _provision_script_preinstall_path
        s.args = [_provision_config_dst_path]
      end
      # DART send config
      node.vm.provision :file do |f|
        f.source = _provision_config_src_path
        f.destination = _provision_config_dst_path
      end
      # DART apply config
      node.vm.provision :shell do |s|
        s.path = _provision_script_postinstall_path
        s.args = [_provision_config_dst_path]
      end
      
      # DART install and config puppet
      node.vm.provision :shell, path: _provision_script_puppet_install_path
      node.vm.provision :shell do |s|
        s.path = _provision_script_puppet_config_path
        s.args = [_shared_puppet_dst_path]
      end
    end
  end

#  config.vm.define "node1" do |node1|
#    # DART using the official CentOS box
#    #node1.vm.box = "centos-7-1511-x86_64"
#    #node1.vm.box_url = "https://dl.dropboxusercontent.com/s/filvjntyct1wuxe/centos-7-1511-x86_64.box"
#    node1.vm.box = "centos/7"
#
#    # DART disabled vmware provider config
#    #node1.vm.provider :vmware_fusion do |v, override|
#    #  override.vm.box = "centos-7-1511-x86_64-vmware"
#    #  override.vm.box_url = "https://dl.dropboxusercontent.com/s/h5g5kqjrzq5dn53/centos-7-1511-x86_64-vmware.box"
#    #end
#
#    node1.vm.hostname = "node1.example.com"
#    # DART disable /vagrant folder because of rsync settings issues with official CentOS box
#    #node1.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
#    node1.vm.synced_folder ".", "/vagrant", disabled: true
#    # DART updated local folder with software installers
#    #node1.vm.synced_folder "/Users/edwin/software", "/software"
#    node1.vm.synced_folder "./software", "/var/tmp/vagrant/software"
#    # DART added "puppet" as synced folder instead of using provision copy mechanism
#    node1.vm.synced_folder "./puppet", "/var/tmp/vagrant/puppet"
#
#    # DART disabled private network
#    #node1.vm.network :private_network, ip: "10.10.10.100"
#
#    # DART disabled vmware provider config
#    #node1.vm.provider :vmware_fusion do |vb|
#    #  vb.vmx["numvcpus"] = "1"
#    #  vb.vmx["memsize"] = "1532"
#    #end
#
#    node1.vm.provider :virtualbox do |vb|
#      # DART updated with Vagrant builtin command
#      vb.customize ["modifyvm", :id, "--memory", "1532"]
#      vb.memory = "1532"
#      # DART updated with Vagrant builtin command
#      #vb.customize ["modifyvm", :id, "--name", "node1"]
#      vb.name = "orawls-node1"
#      # DART forcing 1 cpu
#      vb.cpus = 1
#    end
#
#    # DART disabled inline command, moved below into dedicated script
#    #node1.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppetlabs/code/hiera.yaml;rm -rf /etc/puppetlabs/code/modules;ln -sf /vagrant/puppet/modules /etc/puppetlabs/code/modules"
#    # DART use provision to fix prerequirement
#    node1.vm.provision :file, source: "./config", destination: "/var/tmp/vagrant/config"
#
#    node1.vm.provision :shell, path: "./config/post-install.sh"
#
#    # DART install and config puppet
#    node1.vm.provision :shell, path: "./config/puppet_install.sh"
#    node1.vm.provision :shell, path: "./config/puppet_config.sh"
#
#    # in order to enable this shared folder, execute first the following in the host machine: mkdir log_puppet_weblogic && chmod a+rwx log_puppet_weblogic
#    #node1.vm.synced_folder "./log_puppet_weblogic", "/tmp/log_puppet_weblogic", :mount_options => ["dmode=777","fmode=777"]
#
#    # DART disabled automatic provision with puppet
#    #node1.vm.provision :puppet do |puppet|
#    #  #puppet.environment_path = "puppet/environments"
#    #  puppet.environment_path = "./puppet/environments"
#    #  puppet.environment      = "development"
#    #
#    #  #puppet.manifests_path = "puppet/environments/development/manifests"
#    #  puppet.manifests_path = "./puppet/environments/development/manifests"
#    #  puppet.manifest_file  = "node.pp"
#    #
#    #  puppet.options = [
#    #    '--verbose',
#    #    '--report',
#    #    '--trace',
#    #    #'--debug',
#    #    #'--parser future',
#    #    '--strict_variables',
#    #    #'--hiera_config /vagrant/puppet/hiera.yaml'
#    #    '--hiera_config /var/tmp/vagrant/puppet/hiera.yaml'
#    #  ]
#    #
#    #  puppet.facter = {
#    #    "environment" => "development",
#    #    "vm_type"     => "vagrant",
#    #  }
#    #
#    #end
#
#  end

#  config.vm.define "node2" do |node2|
#    # DART using the official CentOS box
#    #node2.vm.box = "centos-7-1511-x86_64"
#    #node2.vm.box_url = "https://dl.dropboxusercontent.com/s/filvjntyct1wuxe/centos-7-1511-x86_64.box"
#    node2.vm.box = "centos/7"
#
#    # DART disabled vmware provider config
#    #node2.vm.provider :vmware_fusion do |v, override|
#    #  override.vm.box = "centos-7-1511-x86_64-vmware"
#    #  override.vm.box_url = "https://dl.dropboxusercontent.com/s/h5g5kqjrzq5dn53/centos-7-1511-x86_64-vmware.box"
#    #end
#
#    node2.vm.hostname = "node2.example.com"
#    # DART disable /vagrant folder because of rsync settings issues with official CentOS box
#    #node2.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
#    node2.vm.synced_folder ".", "/vagrant", disabled: true
#    # DART updated local folder with software installers
#    #node2.vm.synced_folder "/Users/edwin/software", "/software"
#    node2.vm.synced_folder "./software", "/var/tmp/vagrant/software"
#    # DART added "puppet" as synced folder instead of using provision copy mechanism
#    node2.vm.synced_folder "./puppet", "/var/tmp/vagrant/puppet"
#
#    # DART disabled private network
#    #node2.vm.network :private_network, ip: "10.10.10.200", auto_correct: true
#
#    # DART disabled vmware provider config
#    #node2.vm.provider :vmware_fusion do |vb|
#    #  vb.vmx["numvcpus"] = "1"
#    #  vb.vmx["memsize"] = "1532"
#    #end
#
#    node2.vm.provider :virtualbox do |vb|
#      # DART updated with Vagrant builtin command
#      vb.customize ["modifyvm", :id, "--memory", "1532"]
#      vb.memory = "1532"
#      # DART updated with Vagrant builtin command
#      #vb.customize ["modifyvm", :id, "--name", "node2"]
#      vb.name = "orawls-node2"
#      # DART forcing 1 cpu
#      vb.cpus = 1
#    end
#
#    # DART disabled inline command, moved below into dedicated script
#    #node2.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppetlabs/code/hiera.yaml;rm -rf /etc/puppetlabs/code/modules;ln -sf /vagrant/puppet/modules /etc/puppetlabs/code/modules"
#    # DART use provision to fix prerequirement
#    node2.vm.provision :file, source: "./config", destination: "/var/tmp/vagrant/config"
#
#    node2.vm.provision :shell, path: "./config/post-install.sh"
#
#    # DART install and config puppet
#    node2.vm.provision :shell, path: "./config/puppet_install.sh"
#    node2.vm.provision :shell, path: "./config/puppet_config.sh"
#
#    # in order to enable this shared folder, execute first the following in the host machine: mkdir log_puppet_weblogic && chmod a+rwx log_puppet_weblogic
#    #node2.vm.synced_folder "./log_puppet_weblogic", "/tmp/log_puppet_weblogic", :mount_options => ["dmode=777","fmode=777"]
#
#    # DART disabled automatic provision with puppet
#    #node2.vm.provision :puppet do |puppet|
#    #  #puppet.environment_path = "puppet/environments"
#    #  puppet.environment_path = "./puppet/environments"
#    #  puppet.environment      = "development"
#    #
#    #  #puppet.manifests_path = "puppet/environments/development/manifests"
#    #  puppet.manifests_path = "./puppet/environments/development/manifests"
#    #  puppet.manifest_file  = "node.pp"
#    #
#    #  puppet.options = [
#    #    '--verbose',
#    #    '--report',
#    #    '--trace',
#    #    #'--debug',
#    #    #'--parser future',
#    #    '--strict_variables',
#    #    #'--hiera_config /vagrant/puppet/hiera.yaml'
#    #    '--hiera_config /var/tmp/vagrant/puppet/hiera.yaml'
#    #  ]
#    #
#    #  puppet.facter = {
#    #    "environment" => "development",
#    #    "vm_type"     => "vagrant",
#    #  }
#    #
#    #end
#
#  end
end
