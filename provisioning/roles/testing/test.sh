#!/usr/bin/env bash
#
# Ansible test script.
#
# Usage: [OPTIONS] ./tests/test.sh
#   - cleanup: whether to remove the Docker container after tests (default = true)
#   - container_id: the --name to set for the container (default = timestamp)
#   - test_idempotence: whether to test playbook's idempotence (default = true)
#
# License: MIT
#
# This script was derived from Jeff Geerling's Ansible Role Test Shim Script
# See https://gist.github.com/geerlingguy/73ef1e5ee45d8694570f334be385e181/

# Exit on any individual command failure.
set -e

# Pretty colors.
blue='\033[0;34m'
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

# See http://docs.ansible.com/ansible/intro_configuration.html#force-color
color_opts='env ANSIBLE_FORCE_COLOR=1'

# Default container name. Only chars in [a-zA-Z0-9_.-] are allowed.
timestamp="$(date +%Y-%m-%dT%H.%M.%S_%Z)"

# Allow environment variables to override defaults.
distro='ubuntu1604'
cleanup=${cleanup:-"true"}
container_id=${container_id:-$timestamp}
test_idempotence=${test_idempotence:-"true"}

# See https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
parent_dir_of_this_script="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
host_provis_dir="$(dirname "$(dirname $parent_dir_of_this_script)")"

container_provis_dir="/root/nexus-IaC/provisioning"
container_site_playbook="$container_provis_dir/site.yml"
container_test_playbook="$container_provis_dir/test.yml"
container_inventory="--inventory-file=$container_provis_dir/inventories/docker/hosts"

# From Ansible for DevOps, version 2017-06-02, page 349:
#   Why use an init system in Docker? With Docker, it’s preferable to either
#   run apps directly (as ‘PID 1’) inside the container, or use a tool like Yelp’s
#   dumb-init161 as a wrapper for your app. For our purposes, we’re testing an
#   Ansible role or playbook that could be run inside a container, but is also
#   likely used on full VMs or bare-metal servers, where there will be a real
#   init system controlling multiple internal processes. We want to emulate
#   the real servers as closely as possible, therefore we set up a full init system
#   (systemd or sysv) according to the OS.
init_opts='--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro'
init_exe='/lib/systemd/systemd'

# Run the container using the supplied OS.
printf ${blue}"Starting Docker container: geerlingguy/docker-$distro-ansible."${neutral}"\n"
docker pull geerlingguy/docker-$distro-ansible:latest

# Below is a trick for documenting a long argument list. See https://unix.stackexchange.com/a/152554.
# It turns out that embedding the comments within the list (along with continuation operators) doesn't work:
# https://stackoverflow.com/questions/1455988/commenting-in-bash-script#comment18282079_1456059

# Run container in background.
DOCKER_RUN_PARAMS=(--detach)
# The name of the container. By default, it is a timestamp of when this script was run.
DOCKER_RUN_PARAMS+=(--name $container_id)
# Mount the host's nexus-IaC project directory to the container, with read-only privileges.
DOCKER_RUN_PARAMS+=(--volume=$host_provis_dir:$container_provis_dir:ro)
# Some black magic to make systemD init work in the container.
DOCKER_RUN_PARAMS+=($init_opts)
# Set an environment variable to allow ansible-playbook to find the Ansible configuration file.
# See http://docs.ansible.com/ansible/intro_configuration.html#configuration-file
DOCKER_RUN_PARAMS+=(--env ANSIBLE_CONFIG=$container_provis_dir/ansible.cfg)
# The image to run.
DOCKER_RUN_PARAMS+=(geerlingguy/docker-$distro-ansible:latest)
# The name of the system initialization program that will run first in the container.
DOCKER_RUN_PARAMS+=($init_exe)

docker run "${DOCKER_RUN_PARAMS[@]}"

printf "\n"

# Test Ansible syntax.
printf ${blue}"Checking Ansible playbook syntax."${neutral}
docker exec $container_id ansible-playbook $container_inventory $container_site_playbook --syntax-check

printf "\n"

# Run Ansible playbook.
printf ${blue}"Running playbook: ensure configuration succeeds."${neutral}"\n"
docker exec $container_id $color_opts ansible-playbook $container_inventory $container_site_playbook

# Run Ansible playbook again, if configured.
if [ "$test_idempotence" = true ]; then
  printf ${blue}"Running playbook again: idempotence test"${neutral}
  idempotence=$(mktemp)
  docker exec $container_id $color_opts ansible-playbook $container_inventory $container_site_playbook \
                                        | tee -a $idempotence
  tail $idempotence \
    | grep -q 'changed=0.*failed=0' \
    && (printf ${green}'Idempotence test: pass'${neutral}"\n") \
    || (printf ${red}'Idempotence test: fail'${neutral}"\n" && exit 1)
fi

printf "\n"

# Run integration and functional tests.
printf ${blue}"Running integration and functional tests against live instance."${neutral}
docker exec $container_id $color_opts ansible-playbook $container_inventory $container_test_playbook

printf "\n"

# Remove the Docker container, if configured.
if [ "$cleanup" = true ]; then
  printf ${blue}"Removing Docker container...\n"${neutral}
  docker rm -f $container_id
fi
