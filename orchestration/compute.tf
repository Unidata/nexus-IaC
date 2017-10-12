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
    cidr = "128.117.140.0/24"  // Unidata
  }
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
    cidr = "128.117.153.0/24"  // Unidata
  }
  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "128.117.156.0/24"  // Unidata
  }
  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "52.22.28.125/32"  // jenkins-aws
  }
  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "52.45.185.117/32"  // travis-ci.org. See https://docs.travis-ci.com/user/ip-addresses/
  }
  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "52.54.31.11/32"  // travis-ci.org
  }
  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "54.87.185.35/32"  // travis-ci.org
  }
  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "54.87.141.246/32"  // travis-ci.org
  }
  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "76.120.68.217/32"  // cwardgar
  }
}

resource "openstack_compute_instance_v2" "nexus" {
  name = "nexus-prod"   // Will become hostname of VM.
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
  depends_on = [ "openstack_compute_floatingip_associate_v2.nexus", "openstack_compute_volume_attach_v2.nexus" ]

  provisioner "local-exec" {
    command = "./configure.sh"
  }
}
