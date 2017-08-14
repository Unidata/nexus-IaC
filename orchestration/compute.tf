resource "openstack_compute_keypair_v2" "nexus" {
  name = "nexus-keypair"
  public_key = "${file(var.public_key_path)}"
}

resource "openstack_compute_secgroup_v2" "nexus" {
  name = "nexus-secgroup"
  // We'll be running a software firewall on the instance, so go ahead and allow everything at this level.
  description = "Allow all inbound and outbound IP traffic to/from every address"

  rule {
    ip_protocol = "icmp"
    from_port = "-1"
    to_port = "-1"
    cidr = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "tcp"
    from_port = "1"
    to_port = "65535"
    cidr = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "udp"
    from_port = "1"
    to_port = "65535"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "nexus" {
  name = "nexus-instance"
  image_name = "${var.image}"
  flavor_name = "${var.flavor}"
  key_pair = "${openstack_compute_keypair_v2.nexus.name}"
  security_groups = ["${openstack_compute_secgroup_v2.nexus.name}"]

  network {
    name = "${openstack_networking_network_v2.nexus.name}"
  }
}
