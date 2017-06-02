# Nexus Infrastructure-as-Code

This project contains code for the
[orchestration and configuration](https://blog.gruntwork.io/why-we-use-terraform-and-not-chef-puppet-ansible-saltstack-or-cloudformation-7989dad2865c#3f44)
of a Sonatype Nexus server in the cloud. At first, only orchestration for localhost
(via [Vagrant](https://www.vagrantup.com/)) and [OpenStack](https://www.openstack.org/) are provided.

## Obtaining source

This repository contains [submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules), the source for which will
not be downloaded using the typical `git clone` command. Instead, you'll need to do something like:
```
git clone --recursive git@github.com:cwardgar/nexus-IaC.git
```

## Launching Nexus server in a Vagrant VM

Once you have Vagrant and Ansible installed, simply do:
```
vagrant up
```
