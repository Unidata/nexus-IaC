# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # There are some problems with other boxes, but this one works.
  # See https://bugs.launchpad.net/cloud-images/+bug/1569237/comments/57
  config.vm.box = "bento/ubuntu-16.04"

  config.vm.network :private_network, ip: "192.168.22.22"
  config.vm.hostname = "nexus.dev"
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |v|
    v.memory = 2048
  end

  # Copy Vault password file to a temporary location on target machine. We'll move it in the main playbook.
  config.vm.provision "file", source: "~/.ansible/vault-password", destination: "/tmp/vault-password"

  # Install Python packages needed by Ansible itself.
  config.vm.provision :ansible_local do |ansible|
    ansible.install = true
    ansible.install_mode = "pip"  # We need to install pip anyways in prepare_ansible.yml.
    ansible.inventory_path = "provisioning/inventories/local/hosts"
    ansible.verbose = false
    ansible.playbook = "provisioning/prepare_ansible.yml"
    ansible.config_file = "provisioning/ansible.cfg"
    ansible.limit = "all"  # Do not limit the hosts here; do it in the playbook instead.
  end

  # Provision VM using the main Ansible playbook.
  config.vm.provision :ansible_local do |ansible|
    ansible.install = false
    ansible.inventory_path = "provisioning/inventories/local/hosts"
    ansible.verbose = "v"
    ansible.playbook = "provisioning/site.yml"
    ansible.config_file = "provisioning/ansible.cfg"
    ansible.limit = "all"  # Do not limit the hosts here; do it in the playbook instead.
  end
end
