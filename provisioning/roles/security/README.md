# Security

Performs basic security configuration.

## Inclusion of third-party software

This project contains source code from Jeff Geerling's [ansible-role-security](
https://github.com/geerlingguy/ansible-role-security). It is licensed under the MIT open source license.
A copy of the MIT license can be found in `/licenses/third-party/geerlingguy/`.

### Details of use

`tasks/ssh.yml` is copied from the analogous file in ansible-role-security. Most variable use was eliminated,
preferring simple, hard-coded values instead.
