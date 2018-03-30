#!/usr/bin/env bash

# Exit immediately if any command exits with a non-zero status.
set -e

# Use this version of Ansible everywhere.
ansible_version=2.5.0

sudo pip install --ignore-installed ansible==${ansible_version}
