# Nexus Infrastructure-as-Code

[![Build Status](https://travis-ci.org/cwardgar/nexus-IaC.svg?branch=master)](https://travis-ci.org/cwardgar/nexus-IaC)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This project contains code for the [orchestration and configuration](
https://blog.gruntwork.io/why-we-use-terraform-and-not-chef-puppet-ansible-saltstack-or-cloudformation-7989dad2865c#3f44)
of a Sonatype Nexus server in the cloud. At first, only orchestration for localhost
(via [Vagrant](https://www.vagrantup.com/)) and [OpenStack](https://www.openstack.org/) are provided.

## Working with submodules - IMPORTANT!!

This repository contains [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules), the sources for which
will not be downloaded using the typical `git clone` command. Instead, you'll need to do something like:
```
git clone --recursive https://github.com/cwardgar/nexus-IaC.git
```

However, that's not the only change you'll need to make to your typical Git workflow. Please read this
[cheat sheet](https://medium.com/@porteneuve/mastering-git-submodules-34c65e940407#5450).

### Future

If working with submodules proves too cumbersome or error-prone, give
[git-subrepo](https://github.com/ingydotnet/git-subrepo#readme) a try.

## Launching Nexus server in a Vagrant VM

Once you've installed [Vagrant](https://www.vagrantup.com/downloads.html), [VirtualBox](
https://www.virtualbox.org/wiki/Downloads), and [Ansible](
 http://docs.ansible.com/ansible/latest/intro_installation.html#installing-the-control-machine), simply do:

```
vagrant up
```

You'll be asked for the [Vault password](provisioning/README.md#ansible-vault). Once provided, Ansible will provision
the VM, and when it's done, the Nexus Repository manager will be available at `https://192.168.22.22/`.
The default username is `admin` and the default password is `changeme`.

## Licensing

This software is licensed under the MIT License (MIT). See `LICENSE.md`.

Furthermore, this project includes code from third-party open-source software components, detailed below.

### Roles

All of the Ansible roles in `/provisioning/roles/`--except for `testing` and `security`--are git submodules pointing to
third-party repositories. As such, any licensing terms that those projects have are reproduced in their
respective role directories.

### Testing

See `/provisioning/roles/testing/README.md`.

### Security

See `/provisioning/roles/security/README.md`.

### Ansible plugin

See `/provisioning/callback_plugins/README.md`.
