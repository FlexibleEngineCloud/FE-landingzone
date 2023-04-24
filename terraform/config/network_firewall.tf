# Provision Firewall instances
module "ecs_cluster" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/ecs"

  instance_name  = "firewall"
  instance_count = 2
  availability_zones = ["eu-west-0a","eu-west-0b"]

  flavor_name        = "t2.small"
  key_name           = module.keypair.id
  security_groups    = [module.sg_firewall.name]
  network_uuids      = module.network_vpc.network_ids
  image_id = "caad1499-9388-4222-b604-be2f57a85458"

  tags = {
    Environment = "landingzone"
  }

  metadata = {
    Terraform = "true"
    Environment = "landingzone"
  }

  depends_on = [
    module.keypair,module.sg_firewall,module.network_vpc
  ]
}

module "keypair" {
  source  = "../modules/keypair"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }
  keyname = "TF-KeyPair-firewall"
}

module "sg_firewall" {
  source  = "../modules/secgroup"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  name        = "sg_firewall"
  description = "Security group for firewall instances"
  delete_default_egress_rules = false
  
  ingress_with_source_cidr = [
    {
      from_port   = 10
      to_port     = 1000
      protocol    = "tcp"
      ethertype   = "IPv4"
      source_cidr = "0.0.0.0/0"
    }
  ]
}


module "firewall_eip" {
  source = "../modules/eip"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  eip_count = 3
  eip_name = "external-eip"
  eip_bandwidth = 1000
  protect_eip = true
}


module "antiddos" {
  source = "../modules/antiddos"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  eip_ids = module.firewall_eip.ids

  depends_on = [
    module.firewall_eip
  ]
}
