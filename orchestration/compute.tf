resource "openstack_compute_keypair_v2" "nexus" {
  name = "nexus-keypair"
  public_key = "${file("${path.root}/${var.public_key_path}")}"
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

resource "openstack_compute_floatingip_associate_v2" "nexus" {
  instance_id = "${openstack_compute_instance_v2.nexus.id}"
  floating_ip = "${openstack_networking_floatingip_v2.nexus.address}"
}

resource "null_resource" "dummy" {
  triggers {
    // Trigger the provisioner whenever the compute instance's ID changes, likely because it was recreated.
    compute_instance_id = "${openstack_compute_instance_v2.nexus.id}"
  }

  // We need the floating IP to have been associated with the instance, so that we can use it to connect.
  depends_on = ["openstack_compute_floatingip_associate_v2.nexus"]

  provisioner "local-exec" {
    command = "./configure.sh"
  }
}
