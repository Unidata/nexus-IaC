# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # There are some problems with other boxes, but this one works.
  # See https://bugs.launchpad.net/cloud-images/+bug/1569237/comments/57
  config.vm.box = "bento/ubuntu-16.04"

  config.vm.network :private_network, ip: "192.168.22.22"
  config.vm.hostname = "nexus-dev"
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |v|
    v.memory = 2048
  end

  # Provision VM using the main Ansible playbook.
  config.vm.provision :ansible do |ansible|
    ansible.inventory_path = "provisioning/inventories/vagrant/hosts"
    ansible.verbose = "v"
    ansible.playbook = "provisioning/site.yml"
    ansible.config_file = "provisioning/ansible.cfg"
    ansible.limit = "all"  # Do not limit the hosts here; do it in the playbook instead.
    ansible.ask_vault_pass = true
  end
end
