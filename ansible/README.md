# Ansible

We use [Ansible](https://www.ansible.com/) to provision our machines.

## Content organization

For the most part, the project follows the alternative directory layout described in
[Ansible Best Practices](http://docs.ansible.com/ansible/playbooks_best_practices.html#alternative-directory-layout).

## Ansible Vault

Sensitive data such as passwords and keys are stored in encrypted files using [Ansible Vault](
http://docs.ansible.com/ansible/latest/playbooks_vault.html), rather than as plaintext in the playbooks.
So, in order to run any of the playbooks, you'll need to have the Vault password, which can be found on the
[Unidata Departmental Wiki](https://wiki.ucar.edu/display/unidata/Home) on the "nexus-IaC" page.
With it, you can run `ansible-playbook` with the `--ask-vault-pass` option.

## Execute ad-hoc commands on Vagrant VM

Once you've [launched the Vagrant VM](../README.md#launching-nexus-server-in-a-vagrant-vm), you can do:

```
ansible nexus --inventory=inventories/dev/hosts --verbose --args=date
ansible nexus --inventory=inventories/dev/hosts --verbose --module-name=setup --args='gather_subset=!all'
ansible nexus --inventory=inventories/dev/hosts --verbose --module-name=service --args='name=nexus state=restarted'
```
[Reference](http://docs.ansible.com/ansible/intro_adhoc.html)

### Ansible Vault bug

As of Ansible 2.5.4, these commands may fail with: `ERROR! Attempting to decrypt but no vault secrets found`.
Ansible wants the vault password for some reason, even though the command doesn't interact with any Vault-encrypted
files. This behavior is almost certainly a bug, and I don't believe that it happened in Ansible 2.4 and earlier.

The bug only seems to occur when I execute the commands from the `/nexus-IaC/ansible/` directory. If I change to the
parent directory and do:
```
ansible nexus --inventory=ansible/inventories/dev/hosts --verbose --args=date
```
the command succeeds.

## Execute playbooks on Vagrant VM

`ansible-playbook` should be run from the `ansible/` directory, so that it can find `ansible.cfg`.

[Reference](http://docs.ansible.com/ansible/intro_configuration.html#configuration-file)

```
ansible-playbook --ask-vault-pass --inventory=inventories/dev/hosts --verbose site.yml
ansible-playbook --ask-vault-pass --inventory=inventories/dev/hosts --verbose site.yml --tags "security"
ansible-playbook --ask-vault-pass --inventory=inventories/dev/hosts --verbose site.yml --start-at-task="Include 'ansible-nexus3-oss' role."
```

When using the `--start-at-task` and `--tags` options, the included tasks may rely on variables
that were set in tasks that aren't set to run. These are often `set_fact` tasks. To include them in the run,
add the [`always` tag](http://docs.ansible.com/ansible/playbooks_tags.html#special-tags).

### Backup Nexus application data to S3

```
ansible-playbook --ask-vault-pass --inventory=inventories/dev/hosts --verbose backup.yml
```

### Restore Nexus application data from S3

```
ansible-playbook --ask-vault-pass --inventory=inventories/dev/hosts --verbose restore.yml
```
