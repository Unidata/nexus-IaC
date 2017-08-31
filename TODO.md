# TODO

1. Currently, all playbooks require the vault password in order to run. Can we do better? If so, update the docs too.
1. In Terraform, dynamically generate provisioning/inventories/openstack/hosts using the value of
`"${openstack_networking_floatingip_v2.nexus.address}"`.
1. When provisioning OpenStack host, over 5 minutes is spent upgrading the OS. Perhaps we can take a snapshot after
that process is done (i.e. after 'ansible-debian-upgrade-reboot' completes) and use that as our base image? It would
reduce deployment time.
1. In `prepare_terraform.yml`, generate a `terraform.tfvars` file that contains the values of all Ansible variables
that we must share with Terraform. Such variables include the S3 bucket name, region, and the AWS credentials.
That'll free us from needing to install `~/.aws/credentials` on the machine that runs terraform.
IMPORTANT: Don't forget to add `terraform.tfvars` to `.gitignore`!
