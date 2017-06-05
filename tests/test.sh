#!/bin/bash
#
# Ansible role test shim.
#
# Usage: [OPTIONS] ./tests/test.sh
#   - playbook: a playbook in the tests directory (default = "test.yml")
#   - cleanup: whether to remove the Docker container (default = true)
#   - container_id: the --name to set for the container (default = timestamp)
#   - test_idempotence: whether to test playbook's idempotence (default = true)

# Exit on any individual command failure.
set -e

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

color_opts='env ANSIBLE_FORCE_COLOR=1'

timestamp=$(date +%s)

# Allow environment variables to override defaults.
distro='ubuntu1604'
cleanup=${cleanup:-"true"}
container_id=${container_id:-$timestamp}
test_idempotence=${test_idempotence:-"true"}

container_proj_dir='/root/nexus-IaC'
container_main_playbook="$container_proj_dir/provisioning/site.yml"
container_test_playbook="$container_proj_dir/tests/test.yml"

# Run the container using the supplied OS.
printf ${green}"Starting Docker container: geerlingguy/docker-$distro-ansible."${neutral}"\n"
docker pull geerlingguy/docker-$distro-ansible:latest
docker run --detach --privileged --name $container_id  \
           --volume="$PWD":$container_proj_dir:rw      \
           --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro   \
           geerlingguy/docker-$distro-ansible:latest /lib/systemd/systemd

printf "\n"

# Test Ansible syntax.
printf ${green}"Checking Ansible playbook syntax."${neutral}
docker exec $container_id ansible-playbook $container_main_playbook --syntax-check

printf "\n"

# Run Ansible playbook.
printf ${green}"Running playbook: functional test"${neutral}
docker exec $container_id $color_opts ansible-playbook $container_main_playbook

if [ "$test_idempotence" = true ]; then
  # Run Ansible playbook again (idempotence test).
  printf ${green}"Running playbook again: idempotence test"${neutral}
  idempotence=$(mktemp)
  docker exec $container_id $color_opts ansible-playbook $container_main_playbook | tee -a $idempotence
  tail $idempotence \
    | grep -q 'changed=0.*failed=0' \
    && (printf ${green}'Idempotence test: pass'${neutral}"\n") \
    || (printf ${red}'Idempotence test: fail'${neutral}"\n" && exit 1)
fi

# TODO: Run test playbook here.

# Remove the Docker container (if configured).
if [ "$cleanup" = true ]; then
  printf "Removing Docker container...\n"
  docker rm -f $container_id
fi
