#!/usr/bin/env bash
#
# Script to run the backup playbook. It is meant to be executed by cron as 'nexus_os_user'.

# Cron jobs have a different environment than the interactive shell; specifically, PATH is different.
# So, explicitly set our own PATH so that 'ansible-playbook' will be found successfully.
# See https://askubuntu.com/questions/23009/why-crontab-scripts-are-not-working
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

inventory="--inventory-file=inventories/local/hosts"
password_file="--vault-password-file=~/.ansible/vault-password"

cd "{{ playbook_dir }}"

ansible-playbook $inventory $password_file backup.yml
