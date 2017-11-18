#!/usr/bin/env bash

# Exit immediately if any command exits with a non-zero status.
set -e

# Update the package list
apt-get -y update

# Upgrade all installed packages incl. kernel and kernel headers
# "--force-confnew" means always install the new versions of configuration files.
apt-get -y dist-upgrade -o Dpkg::Options::="--force-confnew"
