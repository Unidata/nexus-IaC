#!/usr/bin/env bash

# Exit immediately if any command exits with a non-zero status.
set -e

# See https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
parent_dir_of_this_script="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ansible_dir="$(dirname $parent_dir_of_this_script)/ansible"

cd $ansible_dir

# See http://docs.ansible.com/ansible/intro_configuration.html#force-color
export ANSIBLE_FORCE_COLOR=1
# See https://github.com/hashicorp/terraform/issues/2661#issuecomment-269866440
export PYTHONUNBUFFERED=1

# This is a Python script that simply prints the value of the VAULT_PASSWORD variable.
# That variable must be added to the environment elsewhere, in a secure manner.
# If it is not available or is incorrect, the 'ansible-vault' command below will fail.
# See http://docs.ansible.com/ansible/latest/playbooks_vault.html#running-a-playbook-with-vault
export ANSIBLE_VAULT_PASSWORD_FILE="$ansible_dir/files/vault-password"

# Decrypt and install private key so that we can connect to OpenStack target.
ansible-vault decrypt --output=~/.ssh/unidata_provisioner_id_rsa files/unidata_provisioner_id_rsa.enc

# Use 'openstack' inventory.
ANSIBLE_OPTIONS=(--inventory-file=inventories/openstack/hosts)
# Verbose mode.
ANSIBLE_OPTIONS+=(--verbose)

# Backup Nexus application data to S3.
ansible-playbook "${ANSIBLE_OPTIONS[@]}" backup.yml
