data "openstack_networking_network_v2" "public_network" {
  name = "${var.public_network}"
}

data "openstack_networking_network_v2" "ceph_network" {
  name = "${var.ceph_network}"
}

resource "openstack_networking_network_v2" "network_1" {
  name           = "dev_network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "dev_subnet"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  cidr       = "10.0.0.0/8"
  ip_version = 4

  allocation_pools = {
    start = "10.0.0.50"
    end   = "10.0.0.100"
  }
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
  name            = "dev_instance_1"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor_name}"
  key_pair        = "${var.key_pair}"
  security_groups = ["default"]

  network {
    name = "${openstack_networking_network_v2.network_1.name}"
  }

  network {
    name = "${data.openstack_networking_network_v2.ceph_network.name}"
  }
}

resource "openstack_compute_floatingip_v2" "fip_1" {
  pool = "${var.public_network}"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_compute_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.instance_1.id}"
}

output "instance_1_private_ip" {
  # an OpenStack instance can take one or more networks
  value = "${openstack_compute_instance_v2.instance_1.network.0.fixed_ip_v4}"
}

output "instance_1_floating_ip" {
  value = "${openstack_compute_floatingip_v2.fip_1.address}"
}
