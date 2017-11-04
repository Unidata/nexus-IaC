#!/usr/bin/env bash
# LOOK: This script assumes that prepare_tools.sh and create_image.sh have been run already.

# Exit immediately if any command exits with a non-zero status.
set -e

# See https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
parent_dir_of_this_script="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
terraform_dir="$(dirname $parent_dir_of_this_script)/terraform"
packer_dir="$(dirname $parent_dir_of_this_script)/packer"

packer_output_file=$packer_dir/packer_output.txt  # Written in create_image.sh
# The other option here is 'cat | tail -n1'. However, that will fail us when the last line is a blank.
# 'tac | head -n1' doesn't suffer from that problem.
last_line_of_packer_output=`tac $packer_output_file | head -n1`

regex="^--> openstack: An image was created: ([0-9a-f-]+)$"

# Determine if $last_line_of_packer_output matches $regex. If not, quit immediately with return code 1.
# Otherwise, capture the image ID from the line and print it. See https://stackoverflow.com/a/15965681/3874643
image_id=`echo $last_line_of_packer_output | sed --regexp-extended "/$regex/! Q1 ; s/$regex/\1/"`

cd $terraform_dir

# Add OpenStack variables to the environment. We created this file in prepare_tools.sh.
source ~/.openstack/openrc.sh

# One-time Terraform initialization.
terraform init -input=false

# Apply the changes.
# See https://www.terraform.io/guides/running-terraform-in-automation.html#auto-approval-of-plans
terraform apply -input=false -auto-approve=true -var "image_id=$image_id"
