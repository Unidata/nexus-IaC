# Packer

This directory contains [Packer](https://www.packer.io) templates for creating images of the Nexus server on
OpenStack and AWS.

## OpenStack image

`builders.networks[0]` is the UUID of "nexus-network", which is created by Terraform. I tried to use the "public"
network that is pre-installed by the Jetstream admins, but I couldn't connect to my instance when I did so.

`builders.security_groups[0]` is the UUID of "nexus-secgroup". If no security group is specified, the one named
"default" is assigned. That one is no good because it blocks all incoming traffic originating from the public
internet. My concern with "nexus-secgroup" is that it's quite restrictive in terms of the IP addresses that it
whitelists. Perhaps "global-ssh-22", which allows SSH traffic from all IPs, would be better?

The `timestamp` variable is in ISO-8601 format, i.e. `yyyy-mm-ddThh:mm:ssZ`. It just looks goofy because Packer's
[`isotime` function](https://www.packer.io/docs/templates/engine.html#isotime-function-format-reference) is weird.

Upon successful image creation, Packer will print:
```
==> Builds finished. The artifacts of successful builds are:
--> openstack: An image was created: 9135240b-2544-40bd-b571-f9059e3176c4
```

WARNING: `packer build openstack.json` will fail if "nexus-network" and "nexus-secgroup" don't already exist.
Those dependencies make the template brittle, but the default resources available in Jetstream (e.g. the "public"
network) are not enough for Packer to be able to do it's thing.

TODO: Can we eliminate those dependencies? If not, we should script Terraform to run both before AND after Packer.
In Terraform's first run, it'll create the "nexus-network" and "nexus-secgroup" resources that Packer needs. In its
second run, Terraform will provision the VM using the image that Packer just created.

## AWS image

The source AMI we're using, `ami-cd0f5cb6`, is a completely bare Ubuntu 16.04.3 image, and on recent versions of
Ubuntu, [Python2 is no longer pre-installed](https://wiki.ubuntu.com/XenialXerus/ReleaseNotes#Python_3).
That screws up Ansible, because its `gather_facts` phase requires Python2 to be installed on the target machine.
So, we must install Python via a shell provisioner before we run Ansible.

The `timestamp` variable is slightly different than the one in `openstack.json` because AMI names cannot contain
colons.

Upon successful image creation, Packer will print:
```
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
us-east-1: ami-4139903b
```
