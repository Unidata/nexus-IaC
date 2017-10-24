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

# Installs Terraform. Decrypts SSH, OpenStack, and AWS credentials and places them in their respective home directories.
ansible-playbook --verbose prepare_terraform.yml

# Add OpenStack variables to the environment. We created this file in prepare_terraform.yml.
source ~/.openstack/openrc.sh

cd ../terraform

# See https://www.terraform.io/guides/running-terraform-in-automation.html#auto-approval-of-plans

# One-time Terraform initialization.
terraform init -input=false
# Taint the VM, which will cause Terraform to recreate it.
terraform taint openstack_compute_instance_v2.nexus -input=false
# Apply the changes.
terraform apply -input=false -auto-approve=true
