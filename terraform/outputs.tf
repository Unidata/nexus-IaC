output "instance-ip-address" {
  value = "${openstack_networking_floatingip_v2.nexus.address}"
}
