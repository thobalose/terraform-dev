variable "public_network" {
  default = "public1"
}

variable "ceph_network" {
  default = "ceph-net"
}

variable "image_name" {
  default = "ubuntu-16.04_working"
}

variable "flavor_name" {
  default = "m1.large"
}

variable "key_pair" {
  default = "oskey"
}
