#!/usr/bin/env bash

# Exit on any individual command failure.
set -e

# See http://docs.ansible.com/ansible/intro_configuration.html#force-color
export ANSIBLE_FORCE_COLOR=1
# See https://github.com/hashicorp/terraform/issues/2661#issuecomment-269866440
export PYTHONUNBUFFERED=1

# See https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
parent_dir_of_this_script="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
provis_dir="$(dirname $parent_dir_of_this_script)/provisioning"

# Change to provisioning directory.
cd $provis_dir

# Wait for target's sshd to accept our connection.
ansible nexus -i inventories/openstack/hosts -m wait_for_connection -a 'timeout=120'

ansible-playbook -i inventories/openstack/hosts -v site.yml
