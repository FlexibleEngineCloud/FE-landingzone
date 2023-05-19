# ECS Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_compute_instance_v2" "instances" {
  availability_zone = element(var.availability_zones, count.index)
  count             = var.instance_count
  name              = var.instance_count > 1 ? format("%s-%d", var.instance_name, count.index + 1) : var.instance_name
  flavor_name       = var.flavor_name
  key_pair          = var.key_name
  user_data         = var.user_data
  image_id          = var.image_id
  security_groups   = var.security_groups

  dynamic "network" {
    for_each = var.network_uuids
    content {
      uuid = network.value
    }
  }

  metadata = merge(
    var.metadata,
    {
      "Name" = var.instance_count > 1 ? format("%s-%d", var.instance_name, count.index + 1) : var.instance_name
    },
  )

  tags = merge(
    var.tags,
    {
      "Name" = var.instance_count > 1 ? format("%s-%d", var.instance_name, count.index + 1) : var.instance_name
    },
  )
}
/*
resource "flexibleengine_compute_interface_attach_v2" "example_interface_attach" {
  instance_id = flexibleengine_compute_instance_v2.instances[0].id
  network_id  = var.network_uuids[0]
  fixed_ip    = "192.168.1.165"
}
*/