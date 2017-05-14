# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # There are some problems with other boxes, but this one works.
  # See https://bugs.launchpad.net/cloud-images/+bug/1569237/comments/57
  config.vm.box = "bento/ubuntu-16.04"

  config.vm.network :private_network, ip: "192.168.66.66"
  config.vm.hostname = "nexus.dev"
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |v|
    v.memory = 1024
  end

  # Ansible provisioner.
  config.vm.provision :ansible do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
    ansible.sudo = true
  end
end
