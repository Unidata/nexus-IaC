# TODO

1. On Travis, use Vault password file. However, when user runs, ask for password interactively.
Storing passwords in plain text is bad!
1. In Terraform, dynamically generate provisioning/inventories/openstack/hosts using the value of
`"${openstack_networking_floatingip_v2.nexus.address}"`.
1. When provisioning OpenStack host, over 5 minutes is spent upgrading the OS. Perhaps we can take a snapshot after that process is done
(i.e. after 'ansible-debian-upgrade-reboot' completes) and use that as our base image? It would reduce deployment time.
