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

# Use 'openstack' inventory.
ANSIBLE_OPTIONS=(--inventory-file=inventories/openstack/hosts)

# Wait for target's sshd to accept our connection.
ansible nexus "${ANSIBLE_OPTIONS[@]}" --module-name=wait_for_connection --args='timeout=120'

# Run main playbook.
ansible-playbook "${ANSIBLE_OPTIONS[@]}" site.yml

# Restore application data from S3. NOTE: When we do something like:
#   terraform taint openstack_compute_instance_v2.nexus && terraform apply
#
# then running restore.yml afterwards COULD result in data loss! It'll happen if the Cinder volume has some data on it
# that's not backed up before it's detached from the old, tainted VM. The data initially survives the migration to the
# new VM, but restore.yml then wipes out any data that's not part of the backup.
#
# Therefore, we've commented this out for now. It's not a bad idea to leave restoration as a manual step anyway.
#ansible-playbook "${ANSIBLE_OPTIONS[@]}" restore.yml
