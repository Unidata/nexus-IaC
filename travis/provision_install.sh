#!/usr/bin/env bash

# Exit on any individual command failure.
set -e

# See http://docs.ansible.com/ansible/intro_configuration.html#force-color
export ANSIBLE_FORCE_COLOR=1
# See https://github.com/hashicorp/terraform/issues/2661#issuecomment-269866440
export PYTHONUNBUFFERED=1

# Gotta jump through a few hoops to get the latest Ansible, which is not available in the default Apt repos.
# See http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-via-apt-ubuntu
sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get -qq update
sudo apt-get install -y ansible

cd $TRAVIS_BUILD_DIR/provisioning

# Installs Terraform. Decrypts OpenStack credentials script and copies them to /etc/profile.d/openrc.sh
ansible-playbook --verbose prepare_terraform.yml

# Prepares Ansible for running the site.yml playbook. Most importantly, it installs the private SSH key needed to
# connect to the OpenStack host.
ansible-playbook --verbose prepare_ansible.yml
