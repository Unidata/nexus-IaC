# Packer

This directory contains [Packer](https://www.packer.io) templates for creating images of the Nexus server on
OpenStack and AWS.

## OpenStack templates

### Unbuntu base template

To build an Ubuntu base image atop which our Nexus application images will be created, execute:

```
packer build openstack-base.json
```

Notes about the image:
* It is fully upgraded, via `apt-get dist-upgrade`.
* The "unattended-upgrades" package has been removed. That package installs services, such as "apt-daily", that perform
Apt operations at boot. That activity was causing our playbooks to fail because they could not gain exclusive access
to `/var/lib/dpkg/lock` or `/var/lib/apt/lists/lock` when they needed to perform their own Apt operations.
* A ton of cruft has been removed to make the image leaner, such as Linux source code and `*-dev` packages.
[The script](scripts/cleanup.sh) for this comes from the [Bento project](
https://github.com/chef/bento/blob/master/ubuntu/scripts/cleanup.sh). Bento is licensed under the Apache License 2.0.
A copy has been included at `/licenses/third-party/bento/LICENSE.txt`.

### Nexus template

To build a Nexus application image, first ensure that `builders[0].source_image_name` refers to the base image that you
just built. You can see the images you've created with `openstack image list`. Then execute:

```
packer build openstack-nexus.json
```

The image is simply the result of running the main playbook with the OpenStack inventory against the temporary VM.

### Common configuration

`builders[0].networks[0]` is the UUID of "nexus-network", which is created by Terraform. I tried to use the "public"
network that is pre-installed by the Jetstream admins, but I couldn't connect to my instance when I did so.

`builders[0].security_groups[0]` is the UUID of "global-ssh-22", which allows SSH traffic from all IP addresses. We
could use "nexus-secgroup" here to significantly limit access to the temporary VMs, but I don't see the point. Besides,
one must still have the Packer-generated, temporary key pair in order to login.

The `timestamp` variable is in ISO-8601 format, i.e. `yyyy-mm-ddThh:mm:ssZ`. It just looks goofy because Packer's
[`isotime` function](https://www.packer.io/docs/templates/engine.html#isotime-function-format-reference) is weird.

`builders[0].user_data_file` configures the behavior of the cloud-init program, which runs against a new VM when it's
first booted.

WARNING: Building the images will fail if "nexus-network" and "global-ssh-22" don't already exist. Those dependencies
make the templates somewhat brittle, but the default resources available in Jetstream (e.g. the "public" network) are
not enough for Packer to be able to do it's thing.

TODO: Can we eliminate those dependencies? If not, we should script Terraform to run both before AND after Packer.
In Terraform's first run, it'll create the "nexus-network" and "global-ssh-22" resources that Packer needs. In its
second run, Terraform will provision the VM using the image that Packer just created.

## Amazon template

### Unbuntu base template

To build an Ubuntu base image atop which our Nexus application images will be created, execute:

```
packer build amazon-base.json
```

The generated AMI ought to have the exact same software and configuration as the analogous OpenStack image.

### Nexus template

To build a Nexus application image, first ensure that `builders[0].source_ami` refers to the base image that you
just built. You can see the images you've created in the AWS web interface under EC2->Images->AMIs. Then execute:

```
packer build amazon-nexus.json
```

The `timestamp` variable is slightly different than the one in the OpenStack templates because AMI names cannot
contain colons.
