resource "openstack_networking_floatingip_v2" "nexus" {
  // According to the Terraform docs, this argument is:
  //   The name of the pool from which to obtain the floating IP.
  // However, recent versions of OpenStack don't have IP pools; instead, addresses come from an external network.
  // See https://ask.openstack.org/en/question/99678. So, this Terraform module is out-of-date but still useable.
  pool = "${var.external_gateway_network["name"]}"
}

resource "openstack_networking_network_v2" "nexus" {
  name           = "nexus-network"
  admin_state_up = true   // Whether the resource is "ON" or not.
}

resource "openstack_networking_subnet_v2" "nexus" {
  name            = "nexus-subnet"
  network_id      = "${openstack_networking_network_v2.nexus.id}"
  cidr            = "192.168.1.0/24"
}

resource "openstack_networking_router_v2" "nexus" {
  name             = "nexus-router"
  admin_state_up   = true   // Whether the resource is "ON" or not.
  external_gateway = "${var.external_gateway_network["id"]}"
}

resource "openstack_networking_router_interface_v2" "nexus" {
  router_id = "${openstack_networking_router_v2.nexus.id}"
  subnet_id = "${openstack_networking_subnet_v2.nexus.id}"
}
