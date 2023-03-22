# Create ECS firewall 1 instance.
resource "flexibleengine_compute_instance_v2" "firewall1" {
  name              = "pfsense1-${random_string.id.result}"
  image_id          = "9791dd1c-6cf4-49ba-a54d-58b89b1960da"
  flavor_id         = "c6.xlarge.2"
  key_pair          = flexibleengine_compute_keypair_v2.keypair.name
  security_groups   = ["default", flexibleengine_networking_secgroup_v2.secgroup_1.name]
  availability_zone = "eu-west-1a"

  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet_in.id
  }
  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet_out.id
  }
  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet_sync.id
  }
  tags = {
    scenario = var.tag
  }
}

# Create ECS firewall 2 instance.
resource "flexibleengine_compute_instance_v2" "firewall2" {
  name              = "pfsense2-${random_string.id.result}"
  image_id          = "9791dd1c-6cf4-49ba-a54d-58b89b1960da"
  flavor_id         = "c6.xlarge.2"
  key_pair          = flexibleengine_compute_keypair_v2.keypair.name
  security_groups   = ["default", flexibleengine_networking_secgroup_v2.secgroup_1.name]
  availability_zone = "eu-west-1c"

  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet_in.id
  }
  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet_out.id
  }
  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet_sync.id
  }
  tags = {
    scenario = var.tag
  }
}

# Create VIP IN
resource "flexibleengine_networking_vip_v2" "vip_in" {
  network_id = flexibleengine_vpc_subnet_v1.subnet_in.id
}

# Attach VIP IN to firewalls
resource "flexibleengine_networking_vip_associate_v2" "vip_associate_in" {
  vip_id = flexibleengine_networking_vip_v2.vip_in.id
  port_ids = [
    flexibleengine_compute_instance_v2.firewall1.network.0.port,
    flexibleengine_compute_instance_v2.firewall2.network.0.port
  ]
}

# Create VIP OUT
resource "flexibleengine_networking_vip_v2" "vip_out" {
  network_id = flexibleengine_vpc_subnet_v1.subnet_out.id
}

# Attach VIP OUT to firewalls
resource "flexibleengine_networking_vip_associate_v2" "vip_associate_out" {
  vip_id = flexibleengine_networking_vip_v2.vip_out.id
  port_ids = [
    flexibleengine_compute_instance_v2.firewall1.network.1.port,
    flexibleengine_compute_instance_v2.firewall2.network.1.port
  ]
}


/*
# Attach EIP address to VIP address.
resource "flexibleengine_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = flexibleengine_vpc_eip.eip_1.publicip.0.ip_address
  instance_id = flexibleengine_compute_instance_v2.firewall.id
}
*/
