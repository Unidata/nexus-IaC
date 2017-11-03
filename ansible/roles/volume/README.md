# Volume

Prepares a volume to store Nexus application data. The volume may or may not be available when this role runs,
and it's designed to do reasonable things in either case.

## When the volume IS NOT available

In this scenario, the target will likely be a temporary OpenStack VM spun up by Packer. Here all we do is add the
`/etc/fstab` entry, which doesn't have any immediate effect, but the entry becomes a part of the image that Packer
generates. Then, when that image is later used to provision a VM, that entry will cause "nexus-volume" to be mounted
on boot, if it's available.

Given that "nexus-volume" is unavailable during image creation, no secondary block device will be mounted to
`data_partition_mount_dir`. So later, when the Nexus server starts writing inside that directory (remember that
`nexus_data_dir: "{{ data_partition_mount_dir }}/nexus"` on OpenStack hosts), the data will be created on the
**primary** boot partition, i.e. `/dev/sda1`. That's significant because everything on `/dev/sda1` will be incorporated
into the generated image.

The result of all this is that we're creating Nexus images with already-existing application data at
`data_partition_mount_dir` on `/dev/sda1`. In one sense, this is a good thing: it means that the images are
self-contained. VMs created from them will function perfectly fine in the event that no volume is attached.
We added the `nofail` option to our `/etc/fstab` entry to make that possible.

But what if we DO attach a volume to a VM provisioned from one of our images? We'll essentially be "mounting over"
the existing directory on `/dev/sda1`. What happens to its contents? As it turns out, [pretty much nothing](
https://unix.stackexchange.com/a/198543). They're just hidden from view, not reachable via normal filesystem traversal.

## When the volume IS available

Packer has allowed us to adopt the [immutable server pattern](https://martinfowler.com/bliki/ImmutableServer.html),
meaning that production machines are provisioned from a base image and never modified, not even by Ansible.
So, that means that the only scenario where we would be running this role against a machine WITH a volume available
would be if we were [recreating "nexus-volume"](#nexus-volume). In any event, we perform the following tasks:

1. Create a primary partition on the block device.
1. Format the partition as an Ext4 filesystem.
1. Mount the partition to the desired directory, creating it first if necessary.
1. Add an entry to `/etc/fstab` that will auto-mount `data_partition_name` to `data_partition_mount_dir` on boot.

### nexus-volume

Currently we don't have an automated way to create and populate "nexus-volume". To do so, we'd need to:

1. Create an empty volume and attach it to a temporary VM running the source image from our OpenStack Packer template.
2. Run our main Ansible playbook against the VM. This will mount the volume and populate it.
3. Delete the VM and all associated resources but NOT the volume.

Step 1 can be automated with Terraform. Simple. Then, step 2 could be initiated by Terraform at the end of step 1
using a "null_resource" provisioner that invokes Ansible. Also simple. The tricky part is step 3, where we must
destroy all resources EXCEPT the volume. Apparently this is possible with [resource targeting](
https://www.terraform.io/docs/commands/plan.html#resource-targeting) in Terraform, but I haven't tried it.

So, in theory, the entire process can be scripted, with the help of Terraform and Ansible. We'll probably never
actually do it though, as creating and populating "nexus-volume" is ideally a one-time operation.

Incidentally, Packer's [`amazon-ebsvolume` builder](https://www.packer.io/docs/builders/amazon-ebsvolume.html)
performs this exact procedure, but only for AWS. In general, Packer provides much better support for AWS than it
does OpenStack, as you'd expect.
