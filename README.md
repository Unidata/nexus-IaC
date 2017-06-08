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

Once you have Vagrant, VirtualBox, and Ansible installed, simply do:
```
vagrant up
```

The Nexus site will then be available at `http://192.168.22.22:8081/`.

## Licensing

This software is licensed under the MIT License (MIT). See `LICENSE.md`.

Furthermore, this project includes code from third-party open-source software components, detailed below.

### Roles

All of the Ansible roles in `provisioning/roles/` are git submodules pointing to third-party repositories.
As such, any licensing terms that those projects have are reproduced in their respective role directories.

The exception to this is `provisioning/roles/nexus/`, which is not a git submodule but does include third-party
code. See `README.md` in that directory for more information.

### Tests

For details, see `/tests/README.md`.
