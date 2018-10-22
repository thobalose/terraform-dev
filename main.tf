resource "openstack_networking_network_v2" "network_1" {
  name           = "dev_network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "dev_subnet"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  cidr       = "10.0.0.0/24"
  ip_version = 4

  allocation_pools = {
    start = "10.0.0.50"
    end   = "10.0.0.100"
  }

  dns_nameservers = "${var.dns_nameservers}"
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "dev_router"
  admin_state_up      = true
  external_network_id = "${data.openstack_networking_network_v2.public_network.id}"
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = "${openstack_networking_router_v2.router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet_1.id}"
}

resource "openstack_compute_instance_v2" "instance_1" {
  name            = "osdev_instance"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor_name}"
  key_pair        = "${var.key_pair}"
  security_groups = ["default", "${openstack_networking_secgroup_v2.ceph_secgroup_1.name}"]

  network {
    name = "${openstack_networking_network_v2.network_1.name}"
  }

  network {
    name = "${data.openstack_networking_network_v2.ceph_network.name}"
  }
}

resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "${var.public_network}"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.instance_1.id}"

  connection {
    host        = "${openstack_networking_floatingip_v2.fip_1.address}"
    user        = "${var.ssh_user}"
    private_key = "${file(var.ssh_key_file)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }
}

resource "openstack_networking_secgroup_v2" "ceph_secgroup_1" {
  name        = "ceph_secgroup_1"
  description = "My ceph_network security group"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6789
  port_range_max    = 6789
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.ceph_secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6789
  port_range_max    = 6789
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.ceph_secgroup_1.id}"
}
