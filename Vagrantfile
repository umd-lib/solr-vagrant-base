# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.vm.box_version = "1.0.1"

  config.vm.hostname = 'solrlocal'
  config.vm.network "private_network", ip: "192.168.40.111"

  config.vm.synced_folder "dist", "/apps/dist"

  # Puppet Modules
  config.vm.provision "shell", inline: <<-SHELL
    # puppetlabs-stdlib is "pinned" to v4.22.0
    puppet module install puppetlabs-stdlib --version 4.22.0
    # puppetlabs-firewall is "pinned" to v1.10.0
    puppet module install puppetlabs-firewall --version 1.10.0
  SHELL

  # system provisioning
  config.vm.provision "puppet", manifest_file: 'solr.pp', environment: 'local'

  # JDK
  config.vm.provision "shell", path: 'scripts/jdk.sh'
  # Solr
  config.vm.provision "shell", path: 'scripts/solr.sh'

  # CSR signing script
  config.vm.provision "file", source: 'files/signcsr', destination: '/apps/ca/signcsr'
  # HTTPS cert generating script
  config.vm.provision "file", source: 'files/https-cert.sh', destination: '/apps/solr/scripts/https-cert.sh'
  # Solr core deploying script
  config.vm.provision "file", source: 'files/core.sh', destination: '/apps/solr/scripts/core.sh'
  # control script
  config.vm.provision "file", source: 'files/control', destination: '/apps/solr/solr/control'
end
