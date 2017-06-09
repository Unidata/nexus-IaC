#!/bin/bash
#
# Ansible test script.
#
# Usage: [OPTIONS] ./tests/test.sh
#   - cleanup: whether to remove the Docker container after tests (default = true)
#   - container_id: the --name to set for the container (default = timestamp)
#   - test_idempotence: whether to test playbook's idempotence (default = true)
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
host_proj_dir="$(dirname $parent_dir_of_this_script)"

container_proj_dir='/root/nexus-IaC'
container_playbook="$container_proj_dir/provisioning/site.yml"

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
docker run --detach --name $container_id --volume=$host_proj_dir:$container_proj_dir:rw $init_opts  \
           geerlingguy/docker-$distro-ansible:latest $init_exe

printf "\n"

# Test Ansible syntax.
printf ${blue}"Checking Ansible playbook syntax."${neutral}
docker exec $container_id ansible-playbook $container_playbook --syntax-check

printf "\n"

# Run Ansible playbook.
printf ${blue}"Running playbook: ensure configuration succeeds."${neutral}"\n"
docker exec $container_id $color_opts ansible-playbook $container_playbook --verbose --skip-tags "test"

# Run Ansible playbook again, if configured.
if [ "$test_idempotence" = true ]; then
  printf ${blue}"Running playbook again: idempotence test"${neutral}
  idempotence=$(mktemp)
  docker exec $container_id $color_opts ansible-playbook $container_playbook --skip-tags "test" \
                                        | tee -a $idempotence
  tail $idempotence \
    | grep -q 'changed=0.*failed=0' \
    && (printf ${green}'Idempotence test: pass'${neutral}"\n") \
    || (printf ${red}'Idempotence test: fail'${neutral}"\n" && exit 1)
fi

printf "\n"

# Run functional tests.
printf ${blue}"Running functional tests against live instance."${neutral}
docker exec $container_id $color_opts ansible-playbook $container_playbook --verbose --tags "test"

printf "\n"

# Remove the Docker container, if configured.
if [ "$cleanup" = true ]; then
  printf ${blue}"Removing Docker container...\n"${neutral}
  docker rm -f $container_id
fi
