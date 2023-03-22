# Create AS Config for AS Group
resource "flexibleengine_as_configuration_v1" "as_config" {
  scaling_configuration_name = "asconfig-${random_string.id.result}"
  instance_config {
    flavor = "s6.small.1"
    image  = "4640f130-663d-4b36-870b-ffd990e4fd1b"
    disk {
      size        = 40
      volume_type = "SATA"
      disk_type   = "SYS"
    }
    key_name = flexibleengine_compute_keypair_v2.keypair.name
  }
}

# Create AS Group 
resource "flexibleengine_as_group_v1" "as_group" {
  scaling_group_name       = "asgroup-${random_string.id.result}"
  desire_instance_number   = 1
  min_instance_number      = 0
  max_instance_number      = 3
  scaling_configuration_id = flexibleengine_as_configuration_v1.as_config.id
  vpc_id                   = flexibleengine_vpc_v1.vpc_dmz.id
  delete_instances         = "yes"
  available_zones          = ["eu-west-1a"]

  networks {
    id = flexibleengine_vpc_subnet_v1.subnet_dmz.id
  }
  security_groups {
    id = flexibleengine_networking_secgroup_v2.secgroup_1.id
  }

  tags = {
    scenario = var.tag
  }
}
