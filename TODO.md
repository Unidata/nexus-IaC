# TODO

1. Remove all updating of the Apt cache. We already update it in the init role, which **always** runs.
1. On Travis, use Vault password file. However, when user runs, ask for password interactively.
Storing passwords in plain text is bad!
1. In Terraform, dynamically generate provisioning/inventories/openstack/hosts using the value of
`"${openstack_networking_floatingip_v2.nexus.address}"`.
