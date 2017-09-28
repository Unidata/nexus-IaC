#!/usr/bin/env bash

# Exit on any individual command failure.
set -e

# Upgrade to the latest version of pip. Note that we cannot simply call "sudo pip" on Amazon Linux:
# https://stackoverflow.com/questions/32020594
sudo `which pip` install --upgrade pip

# Install Ansible via pip. This is okay for simple playbooks like backup.yml, but more complicated playbooks are likely
# going to require the "full" Ansible installation. For example, prepare_terraform with pip's ansible, I get:
#   failed: [localhost] (item=jq) => {"failed": true, "item": "jq", "msg":
#     "Could not import python modules: apt, apt_pkg. Please install python-apt package."}
sudo `which pip` install --upgrade ansible

# See http://docs.ansible.com/ansible/intro_configuration.html#force-color
export ANSIBLE_FORCE_COLOR=true
# See https://github.com/hashicorp/terraform/issues/2661#issuecomment-269866440
export PYTHONUNBUFFERED=1
# VAULT_PASSWORD will also be provided, by the Credentials Binding plugin.
export ANSIBLE_VAULT_PASSWORD_FILE=$WORKSPACE/provisioning/files/vault-password

cd $WORKSPACE/provisioning

# Decrypt and install private key so that we can connect to OpenStack target.
ansible-vault decrypt --output=~/.ssh/unidata_provisioner_id_rsa files/unidata_provisioner_id_rsa.enc

# Use 'openstack' inventory.
ANSIBLE_OPTIONS=(--inventory-file=inventories/openstack/hosts)
# Verbose mode.
ANSIBLE_OPTIONS+=(--verbose)

# Backup Nexus application data to S3.
ansible-playbook "${ANSIBLE_OPTIONS[@]}" backup.yml
