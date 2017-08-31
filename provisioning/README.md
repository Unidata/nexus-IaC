# Provisioning

We use [Ansible](ansible.com) to provision our machines.

## Content organization

For the most part, the project follows the alternative directory layout described in
[Ansible Best Practices](http://docs.ansible.com/ansible/playbooks_best_practices.html#alternative-directory-layout).

## Ansible Vault

Sensitive data such as passwords and keys are stored in encrypted files using [Ansible Vault](
http://docs.ansible.com/ansible/latest/playbooks_vault.html), rather than as plaintext in the playbooks.
So, in order to run any of the playbooks, you'll need to have the Vault password (ask Christian for it).

## Execute ad-hoc commands on Vagrant VM

Once you've [launched the Vagrant VM](../README.md#launching-nexus-server-in-a-vagrant-vm), you can do:

```
ansible nexus -i inventories/vagrant/hosts -v -a date
ansible nexus -i inventories/vagrant/hosts -v -m setup -a 'gather_subset=!all'
ansible nexus -i inventories/vagrant/hosts -v -m service -a 'name=nexus state=restarted'
```
[Reference](http://docs.ansible.com/ansible/intro_adhoc.html)

## Execute playbooks on Vagrant VM

`ansible-playbook` should be run from the `provisioning/` directory, so that it can find `ansible.cfg`.

[Reference](http://docs.ansible.com/ansible/intro_configuration.html#configuration-file)

```
ansible-playbook --ask-vault-pass -i inventories/vagrant/hosts -v site.yml
ansible-playbook --ask-vault-pass -i inventories/vagrant/hosts -v site.yml --tags "nexus"
ansible-playbook --ask-vault-pass -i inventories/vagrant/hosts -v site.yml --start-at-task="Install Nexus as a service"
```

When using the `--start-at-task` and `--tags` options, the included tasks may rely on variables
that were set in tasks that aren't set to run. These are often `set_fact` tasks. To include them in the run,
add the [`always` tag](http://docs.ansible.com/ansible/playbooks_tags.html#special-tags).

### Backup Nexus application data to S3

```
ansible-playbook --ask-vault-pass -i inventories/vagrant/hosts -v backup.yml
```

### Restore Nexus application data from S3

```
ansible-playbook --ask-vault-pass -i inventories/vagrant/hosts -v restore.yml
```
