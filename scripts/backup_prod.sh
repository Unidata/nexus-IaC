#!/usr/bin/env bash

# Exit on any individual command failure.
set -e

# See https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
parent_dir_of_this_script="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ansible_dir="$(dirname $parent_dir_of_this_script)/ansible"

cd $ansible_dir

# See http://docs.ansible.com/ansible/intro_configuration.html#force-color
export ANSIBLE_FORCE_COLOR=1
# See https://github.com/hashicorp/terraform/issues/2661#issuecomment-269866440
export PYTHONUNBUFFERED=1
# VAULT_PASSWORD will also be provided by the Credentials Binding plugin.
export ANSIBLE_VAULT_PASSWORD_FILE=files/vault-password

# Decrypt and install private key so that we can connect to OpenStack target.
ansible-vault decrypt --output=~/.ssh/unidata_provisioner_id_rsa files/unidata_provisioner_id_rsa.enc

# Use 'openstack' inventory.
ANSIBLE_OPTIONS=(--inventory-file=inventories/openstack/hosts)
# Verbose mode.
ANSIBLE_OPTIONS+=(--verbose)

# Backup Nexus application data to S3.
ansible-playbook "${ANSIBLE_OPTIONS[@]}" backup.yml
