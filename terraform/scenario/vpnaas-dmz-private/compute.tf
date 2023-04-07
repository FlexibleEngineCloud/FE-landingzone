# Create ECS instance1 for private subnet.
resource "flexibleengine_compute_instance_v2" "instance1" {
  name              = "instance1-${random_string.id.result}"
  image_id          = "4640f130-663d-4b36-870b-ffd990e4fd1b"
  flavor_id         = "s6.small.1"
  key_pair          = flexibleengine_compute_keypair_v2.keypair.name
  security_groups   = ["default", flexibleengine_networking_secgroup_v2.secgroup_1.name]
  availability_zone = "eu-west-1a"

  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet_private.id
  }
  tags = {
    scenario = var.tag
  }
}

# Create ECS instance2 for private subnet.
resource "flexibleengine_compute_instance_v2" "instance2" {
  name              = "instance2-${random_string.id.result}"
  image_id          = "4640f130-663d-4b36-870b-ffd990e4fd1b"
  flavor_id         = "s6.small.1"
  key_pair          = flexibleengine_compute_keypair_v2.keypair.name
  security_groups   = ["default", flexibleengine_networking_secgroup_v2.secgroup_1.name]
  availability_zone = "eu-west-1a"

  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet_private.id
  }
  tags = {
    scenario = var.tag
  }
}
