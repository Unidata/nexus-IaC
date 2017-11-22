#!/usr/bin/env bash
# LOOK: This script assumes that prepare_tools.sh has been run already.

# Exit immediately if any command exits with a non-zero status.
set -e

# See https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
parent_dir_of_this_script="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
packer_dir="$(dirname $parent_dir_of_this_script)/packer"

cd $packer_dir

# Add OpenStack variables to the environment. We created this file in prepare_tools.sh.
source ~/.openstack/openrc.sh

# Invoke Packer. Copy output to both STDOUT and packer_output.txt.
# We'll need to grab the ID of the generated image from packer_output.txt when we run Terraform later.
packer build -color=false openstack-nexus.json | tee packer_output.txt
