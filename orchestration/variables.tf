/////////////////////////////// For S3 remote backend ///////////////////////////////

variable "bucket" {
  default = "unidata-terraform-state"
}

variable "key" {
  default = "nexus-prod/terraform.tfstate"
}

variable "region" {
  default = "us-east-1"
}

variable "encrypt" {
  default = true
}

/////////////////////////////// For OpenStack ///////////////////////////////

variable "image" {
  // See available images with: openstack image list
  default = "JS-API-Featured-Ubuntu16-Jun-8-2017"
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
    name  = "public"
    id    = "865ff018-8894-40c2-99b7-d9f8701ddb0b"
  }
}

variable "volume_size" {  // In gigabytes.
  default = 300
}

// The path to the public SSH key, relative to the Terraform root module (i.e. the 'orchestration' directory).
variable "public_key_path" {
  description = "The path of the ssh pub key"
  default = "../provisioning/files/unidata_provisioner_id_rsa.pub"
}
