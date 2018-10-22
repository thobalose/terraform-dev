data "openstack_networking_network_v2" "public_network" {
  name = "${var.public_network}"
}

data "openstack_networking_network_v2" "ceph_network" {
  name = "${var.ceph_network}"
}
