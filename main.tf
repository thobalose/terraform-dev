resource "openstack_networking_network_v2" "network_1" {
  name           = "78034_network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "78034_subnet"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  cidr       = "10.0.1.0/24"
  ip_version = 4

  allocation_pools = {
    start = "10.0.1.10"
    end   = "10.0.1.20"
  }
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "78034_router"
  admin_state_up      = true
  external_network_id = "29a79bd0-8740-45f1-861b-93562b57dedb"
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = "${openstack_networking_router_v2.router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet_1.id}"
}

resource "openstack_compute_instance_v2" "basic" {
  name            = "78034_basic_instance"
  image_name      = "ubuntu-16.04_working"
  flavor_name     = "m1.small"
  key_pair        = "OSVM"
  security_groups = ["default"]

  network {
    name = "${openstack_networking_network_v2.network_1.name}"
  }
}

resource "openstack_compute_floatingip_v2" "fip_1" {
  pool = "public1"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_compute_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.basic.id}"
}
