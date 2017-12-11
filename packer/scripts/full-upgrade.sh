#!/usr/bin/env bash

# Exit immediately if any command exits with a non-zero status.
set -e

# Update the package list
apt-get -y update

# See https://devops.stackexchange.com/questions/1139
export DEBIAN_FRONTEND=noninteractive

# Completely bare distributions of Ubuntu 16.04 no longer come with Python2 pre-installed
# (see https://wiki.ubuntu.com/XenialXerus/ReleaseNotes#Python_3). That screws up Ansible, because its "gather_facts"
# phase requires Python2 to be installed on the target machine. Here we do that installation.
sudo apt install -yq python-minimal

# Upgrade all installed packages including kernel and kernel headers.
# "--force-confnew" means always install the new versions of configuration files.
apt-get -yq dist-upgrade -o Dpkg::Options::="--force-confnew"
