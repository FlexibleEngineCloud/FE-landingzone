# Create AS Config for AS Group
resource "flexibleengine_as_configuration_v1" "as_config" {
  scaling_configuration_name = "asconfig-${random_string.id.result}"
  instance_config {
    flavor = "s6.small.1"
    image  = "c2280a5f-159f-4489-a107-7cf0c7efdb21"
    disk {
      size        = 40
      volume_type = "SATA"
      disk_type   = "SYS"
    }
    key_name  = flexibleengine_compute_keypair_v2.keypair.name
  }
}

# Create AS Group with ELB 
resource "flexibleengine_as_group_v1" "as_group_with_elb" {
  scaling_group_name       = "asgroup-${random_string.id.result}"
  desire_instance_number   = 1
  min_instance_number      = 0
  max_instance_number      = 3
  scaling_configuration_id = flexibleengine_as_configuration_v1.as_config.id
  vpc_id                   = flexibleengine_vpc_v1.vpc_dmz.id
  delete_instances         = "yes"
  available_zones = ["eu-west-0a", "eu-west-0b","eu-west-0c"]

  networks {
    id = flexibleengine_vpc_subnet_v1.subnet_dmz.id
  }
  security_groups {
    id = flexibleengine_networking_secgroup_v2.secgroup_1.id
  }
  lbaas_listeners {
    pool_id = flexibleengine_lb_pool_v3.pool.id
    protocol_port = 8080
  }

  tags = {
    scenario  = var.tag
  }
}