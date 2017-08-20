#!/usr/bin/env bash

# Gotta jump through a few hoops to get the latest Ansible, which is not available in the default Apt repos.
# See http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-via-apt-ubuntu
apt-get install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get -qq update
apt-get install -y ansible

cd $TRAVIS_BUILD_DIR/provisioning

# Installs Terraform. Decrypts OpenStack credentials script and copies them to /etc/profile.d/openrc.sh
ansible-playbook -i inventories/local/hosts -v prepare_terraform.yml

# Adds OpenStack variables to the environment.
source /etc/profile.d/openrc.sh

# Prepares Ansible for running the site.yml playbook. Most importantly, it installs the private SSH key needed to
# connect to the OpenStack host.
ansible-playbook -i inventories/local/hosts -v prepare_ansible.yml
