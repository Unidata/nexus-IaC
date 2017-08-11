variable "image" {
  // See available images with: openstack image list
  default = "JS-API-Featured-Ubuntu16-Jun-8-2017"
}

variable "flavor" {
  // See available flavors with: openstack flavor list
  default = "m1.small"
}

// We cannot ourselves create a gateway to the public internet; instead, we must use the network that the Jetstream
// admins have established for us. It is called 'public'. To get its details, run: openstack network show public
variable "external_gateway_network" {
  type = "map"
  default = {
    name  = "public"
    id    = "865ff018-8894-40c2-99b7-d9f8701ddb0b"
  }
}

// This is only temporary; the images we build with Packer will be provisioned by Ansible, which will bake the
// required SSH keys right in.
variable "public_key_path" {
  description = "The path of the ssh pub key"
  default = "~/.ssh/id_rsa.pub"
}
