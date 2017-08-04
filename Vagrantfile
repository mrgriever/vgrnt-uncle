# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below.
# The "2" in Vagrant.configure configures the configuration version.
# Please don't change it unless you know what you're doing.
Vagrant.configure("2") do |config|

  config.vm.box = "debian/stretch64"
  config.vm.hostname = "Uncle"
  
  # To manually check for box updates, run `vagrant box outdated`
  config.vm.box_check_update = false
  
  config.vm.provider "virtualbox" do |vb|
    vb.name = "Younique - Uncle"
	vb.cpus = "1"
	vb.memory = "1024"
	#vb.gui = true
  end
  
  config.vm.network "forwarded_port", guest: 80, host: 8082
  config.vm.network "private_network", ip: "10.10.10.20"
  
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.synced_folder "../uncle-src", "/var/www/uncle", type: "virtualbox", mount_options: ["dmode=777,fmode=777"]
  config.vm.synced_folder "./nginx-sites-enabled", "/etc/nginx/sites-enabled", type: "virtualbox", mount_options: ["dmode=777,fmode=777"]

  config.vm.provision :shell, :path => "./provision.sh"
  config.vm.provision :shell, :inline => "sudo service nginx restart", :run => "always"
  
end
