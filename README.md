# Nexus Infrastructure-as-Code

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This project contains code for the provisioning of a Nexus Repository Manager 3 instance in the [Jetstream cloud](
https://jetstream-cloud.org/). The server is intended to be an [immutable](
https://martinfowler.com/bliki/ImmutableServer.html) [phoenix](https://martinfowler.com/bliki/PhoenixServer.html),
meaning that we don't modify it once it's running. Instead, we frequently burn down the old instance of the server and
launch a new one in its place. The new instance contains all of the changes we've committed to this repository, as well
as updates of all installed packages. The procedure is implemented in a [Jenkins pipeline](
jenkins/nexus-reprovision-pipeline.groovy).

## Working with submodules - IMPORTANT!!

This repository contains [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules), the sources for which
will not be downloaded using the typical `git clone` command. Instead, you'll need to do something like:
```
git clone --recursive https://github.com/cwardgar/nexus-IaC.git
```

However, that's not the only change you'll need to make to your typical Git workflow. Please read this
[cheat sheet](https://medium.com/@porteneuve/mastering-git-submodules-34c65e940407#5450).

## Launching Nexus server in a Vagrant VM

Once you've installed [Vagrant](https://www.vagrantup.com/downloads.html), [VirtualBox](
https://www.virtualbox.org/wiki/Downloads), and [Ansible](
 http://docs.ansible.com/ansible/latest/intro_installation.html#installing-the-control-machine), simply do:

```
vagrant up
```

You'll be asked for the [Vault password](ansible/README.md#ansible-vault). Once provided, Ansible will provision
the VM, and when it's done, the Nexus Repository Manager will be available at `https://192.168.22.22/`.
The admin username is `admin`. The admin password is assigned to the `vault_nexus_admin_password` variable in
`ansible/group_vars/all/vault.yml`. `vault.yml` is encrypted by Ansible Vault, and in order to decrypt it,
you'll need the Vault password. Then, run the command:

```
ansible-vault view --ask-vault-pass ansible/group_vars/all/vault.yml
```

## Licensing

This software is licensed under the MIT License (MIT). See `LICENSE.md`.

Furthermore, this project includes code from third-party open-source software components, detailed below.

### Roles

All of the Ansible roles in `/ansible/roles/`—except for `init`, `security`, `testing`, and `volume`—are git submodules
pointing to third-party repositories. As such, any licensing terms that those projects have are
reproduced in their respective role directories.

### Testing

See `/ansible/roles/testing/README.md`.

### Security

See `/ansible/roles/security/README.md`.

### Ansible plugin

See `/ansible/callback_plugins/README.md`.

### Packer provision script

See `/packer/README.md`
