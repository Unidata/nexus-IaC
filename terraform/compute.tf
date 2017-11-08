resource "openstack_compute_keypair_v2" "nexus" {
  name = "nexus-keypair"
  public_key = "${file("${path.root}/${var.public_key_path}")}"
}

resource "openstack_compute_secgroup_v2" "nexus" {
  name = "nexus-secgroup"
  description = "Allow ICMP, HTTP, and HTTPS from all; allow SSH from select IP addresses."

  // By default, allow all outbound traffic and block all inbound traffic.
  // Below are rules that selectively permit inbound traffic.

  // Allow all ICMP inbound traffic, for 'ping'. LOOK: Might be able to narrow this.
  rule {
    ip_protocol = "icmp"
    from_port = "-1"
    to_port = "-1"
    cidr = "0.0.0.0/0"
  }
  // Allow HTTP traffic from all IPs.
  rule {
    ip_protocol = "tcp"
    from_port = "80"
    to_port = "80"
    cidr = "0.0.0.0/0"
  }
  // Allow HTTPS traffic from all IPs.
  rule {
    ip_protocol = "tcp"
    from_port = "443"
    to_port = "443"
    cidr = "0.0.0.0/0"
  }
  // Allow HTTP traffic on 8081 from localhost. Nexus runs at 127.0.0.1:8081 and we need to be able to access it
  // from localhost in order to determine if the server is ready (i.e. after a restart).
  rule {
    ip_protocol = "tcp"
    from_port = "8081"
    to_port = "8081"
    cidr = "127.0.0.1/32"
  }

  // Allow SSH traffic from a limited set of IPs.
  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "128.117.144.0/24"  // Unidata
  }
  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "34.236.85.159/32"  // jenkins-aws
  }
}

resource "openstack_compute_instance_v2" "nexus" {
  name = "nexus-prod"   // Will become hostname of VM.
  image_id = "${var.image_id}"
  flavor_name = "${var.flavor}"
  key_pair = "${openstack_compute_keypair_v2.nexus.name}"
  security_groups = ["${openstack_compute_secgroup_v2.nexus.name}"]
  stop_before_destroy = true

  network {
    name = "${openstack_networking_network_v2.nexus.name}"
  }
}

resource "openstack_compute_floatingip_associate_v2" "nexus" {
  instance_id = "${openstack_compute_instance_v2.nexus.id}"
  floating_ip = "${openstack_networking_floatingip_v2.nexus.address}"
}
