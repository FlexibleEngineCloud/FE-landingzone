# Create ECS firewall instance.
resource "flexibleengine_compute_instance_v2" "firewall" {
  name            = "pfsense-${random_string.id.result}"
  image_id        = "901cd8cc-e1aa-4065-8479-6d5e6bfce272"
  flavor_id       = "s6.medium.2"
  key_pair        = flexibleengine_compute_keypair_v2.keypair.name
  security_groups = ["default",flexibleengine_networking_secgroup_v2.secgroup_1.name]

  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet-in.id
  }
  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet-out.id
  }
  tags = {
    scenario  = "multi-vpc-north-south-filtering"
  }
}

# Create EIP public ip address.
resource "flexibleengine_vpc_eip" "eip_1" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name = "eip-${random_string.id.result}"
    size = 5
    share_type = "PER"
    charge_mode = "traffic"
  }
  tags = {
    scenario  = "multi-vpc-north-south-filtering"
  }
}
# Attach EIP address to Firewall NIC out interface.
resource "flexibleengine_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = flexibleengine_vpc_eip.eip_1.publicip.0.ip_address
  instance_id = flexibleengine_compute_instance_v2.firewall.id
}