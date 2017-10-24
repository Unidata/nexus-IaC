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

# Use 'openstack' inventory.
ANSIBLE_OPTIONS=(--inventory-file=inventories/openstack/hosts)
# Verbose mode.
ANSIBLE_OPTIONS+=(--verbose)

# Wait for target's sshd to accept our connection.
ansible nexus "${ANSIBLE_OPTIONS[@]}" --module-name=wait_for_connection --args='timeout=120'

# Run main playbook.
ansible-playbook "${ANSIBLE_OPTIONS[@]}" site.yml
