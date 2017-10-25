variable "image" {
  // This is a snapshot created by cwardgar. It was created by starting out with "JS-API-Featured-Ubuntu16-Jun-8-2017"
  // as a base image and then updating all software (even the kernel) to the latest versions, using just the
  // 'ansible-debian-upgrade-reboot' role in site.yml. As of 2017-09-03, it shaves over 4 minutes off the OpenStack
  // provisioning time compared to using the JS-API base image.
  // See available images with: openstack image list
  default = "ubuntu-16.04.3-fully-updated-20171025"
}

variable "flavor" {
  // See available flavors with: openstack flavor list
  default = "m1.medium"
}

// We cannot ourselves create a gateway to the public internet; instead, we must use the network that the Jetstream
// admins have established for us. It is called 'public'. To get its details, run: openstack network show public
variable "external_gateway_network" {
  type = "map"
  default = {
    name = "public"
    id = "4367cd20-722f-4dc2-97e8-90d98c25f12e"
  }
}

variable "volume_size" {  // In gigabytes.
  default = 300
}

// The path to the public SSH key, relative to the Terraform root module (i.e. the 'terraform' directory).
variable "public_key_path" {
  description = "The path of the ssh pub key"
  default = "../ansible/files/unidata_provisioner_id_rsa.pub"
}
