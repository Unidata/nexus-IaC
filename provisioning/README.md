# Provisioning

We use [Ansible](ansible.com) to provision our machines.

## Content organization

For the most part, the project follows the alternative directory layout described in
[Ansible Best Practices](http://docs.ansible.com/ansible/playbooks_best_practices.html#alternative-directory-layout).

## Execute ad-hoc commands on Vagrant VM

```
ansible nexus -i inventories/vagrant/hosts -a date
ansible nexus -i inventories/vagrant/hosts -m setup -a 'gather_subset=!all'
```
[Reference](http://docs.ansible.com/ansible/intro_adhoc.html)

## Execute playbooks on Vagrant VM

```
ansible-playbook -i inventories/vagrant/hosts foo.yml
ansible-playbook -i inventories/vagrant/hosts site.yml --start-at-task="Install Nexus as a service"
ansible-playbook -i inventories/vagrant/hosts site.yml --tags "configuration,packages"
```
