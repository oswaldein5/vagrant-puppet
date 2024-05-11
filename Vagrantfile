# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.box = "bento/ubuntu-22.04"

	config.vm.network "forwarded_port", guest: 80, host: 8080

	config.vm.provider "virtualbox" do |vb|
		vb.memory = "2048"
	end

	# Puppet provision
	config.vm.provision "shell", inline: <<-SHELL
		sudo wget https://apt.puppet.com/puppet7-release-focal.deb
		sudo dpkg -i puppet7-release-focal.deb
		sudo apt-get update
		sudo apt-get install puppet-agent -y
		sudo systemctl start puppet
		sudo systemctl enable puppet
	SHELL

	config.vm.provision "puppet" do |puppet|
		puppet.module_path = "modules"        
		puppet.manifests_path = "manifests"   # Default
		puppet.manifest_file = "default.pp"   # Default
	end
end
