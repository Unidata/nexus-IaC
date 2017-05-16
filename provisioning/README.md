# Requirements

nexus-IaC depends on several [Ansible roles](http://docs.ansible.com/ansible/playbooks_roles.html#roles) available on
[Ansible Galaxy](https://galaxy.ansible.com/). They are listed in the `requirements.yml` file. We most install them
locally before we run the playbook, or else we'll get errors like:
```
ERROR! the role 'ansiblebit.oracle-java' was not found in
/Users/cwardgar/dev/projects/nexus-IaC/provisioning/roles:
/etc/ansible/roles:
/Users/cwardgar/dev/projects/nexus-IaC/provisioning
```
To install them, simply run the following command in this directory:
```
ansible-galaxy install -r requirements.yml
```
