#!/usr/bin/env bash

# Exit on any individual command failure.
set -e

# Add OpenStack variables to the environment. We created this file in provision_install.sh.
source ~/.openstack/openrc.sh

cd $TRAVIS_BUILD_DIR/orchestration
terraform init
terraform apply
