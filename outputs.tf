output "instance_1_private_ip" {
  value = "${openstack_compute_instance_v2.instance_1.network.0.fixed_ip_v4}"
}

output "instance_1_ceph_net_ip" {
  value = "${openstack_compute_instance_v2.instance_1.network.1.fixed_ip_v4}"
}

output "instance_1_floating_ip" {
  value = "${openstack_networking_floatingip_v2.fip_1.address}"
}
