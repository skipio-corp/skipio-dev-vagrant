# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |conf|

  conf.vm.define "skipio" do |config|
    # The most common configuration options are documented and commented below.
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com.
    config.vm.hostname = 'skipio.dev.local'

    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://vagrantcloud.com/search.
    config.vm.box = "bento/ubuntu-16.04"

    config.ssh.insert_key = false

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    # NOTE: This will enable public access to the opened port
    config.vm.network "forwarded_port", guest: 3030, host: 3000
    #onfig.vm.network "forwarded_port", guest: 5000, host: 5050

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    config.vm.network "private_network", ip: "192.168.30.30"

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    #config.vm.synced_folder "../skipio", "/home/skipio/skipio", create: true, type: "rsync",
    #  rsync__args: ["--rsync-path='sudo rsync'"]
    config.vm.synced_folder "../skipio", "/home/vagrant/skipio", create: true

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:
    #
    config.vm.provider "virtualbox" do |vb|
      vb.cpus = 1
      vb.memory = "1024"
    end

    #
    # View the documentation for the provider you are using for more
    # information on available options.
    config.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "provisioning/skipio.yml"
      ansible.verbose = true
      ansible.host_vars = {
        "skipio" => {"ansible_python_interpreter" => "/usr/bin/python"}
      }
    end

    config.vm.provision :shell, path: "bootstrap.sh", run:'always'

  end
end
