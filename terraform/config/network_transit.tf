# Provision Network VPC and Subnets
module "network_vpc" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/vpc"

  vpc_name = "vpc"
  vpc_cidr = "192.168.0.0/16"
  vpc_subnets = [{
    subnet_cidr       = "192.168.1.0/24"
    subnet_gateway_ip = "192.168.1.1"
    subnet_name       = "subnet-in"
    },
    {
      subnet_cidr       = "192.168.2.0/24"
      subnet_gateway_ip = "192.168.2.1"
      subnet_name       = "subnet-out"
    },
    {
      subnet_cidr       = "192.168.3.0/24"
      subnet_gateway_ip = "192.168.3.1"
      subnet_name       = "subnet-sync"
    }
  ]
}


# Provision Virtual inbound IP
module "network_vip_in" {
  source = "../modules/vip"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  vip_name   = "inbound-vip"
  ip_address = "192.168.1.101"
  subnet_id  = module.network_vpc.network_ids[0]
  port_ids   = [for instance_network in module.ecs_cluster.network : instance_network.0.port]

  depends_on = [
    module.network_vpc, module.ecs_cluster
  ]
}

# Provision Virtual outbound IP
module "network_vip_out" {
  source = "../modules/vip"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  vip_name   = "outbound-vip"
  ip_address = "192.168.2.101"
  subnet_id  = module.network_vpc.network_ids[1]
  port_ids   = [for instance_network in module.ecs_cluster.network : instance_network.1.port]

  depends_on = [
    module.network_vpc, module.ecs_cluster
  ]
}


# Provision Public IP
module "firewall_eip" {
  source = "../modules/eip"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  eip_count     = 1
  eip_name      = "external-eip"
  eip_bandwidth = 1000
  protect_eip   = true

  depends_on = [
    module.network_vip_in, module.network_vip_out
  ]
}

# Assign AntiDDOS
module "antiddos" {
  source = "../modules/antiddos"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }
  
  eips = [
    for id in module.firewall_eip.ids : {
      floating_ip_id         = id
      enable_l7              = true
      traffic_pos_id         = 3
      http_request_pos_id    = 3
      cleaning_access_pos_id = 2
      app_type_id            = 1
    }
  ]

  depends_on = [
    module.firewall_eip
  ]
}


module "keypair" {
  source = "../modules/keypair"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }
  keyname = "TF-KeyPair-firewall"
}

module "sg_firewall" {
  source = "../modules/secgroup"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  name                        = "sg_firewall"
  description                 = "Security group for firewall instances"
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



# Provision Firewall instances
module "ecs_cluster" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/ecs"

  instance_name      = "firewall"
  instance_count     = 2
  availability_zones = ["eu-west-0a", "eu-west-0b"]

  flavor_name     = "t2.small"
  key_name        = module.keypair.id
  security_groups = [module.sg_firewall.name]
  network_uuids   = module.network_vpc.network_ids
  image_id        = "caad1499-9388-4222-b604-be2f57a85458"

  tags = {
    Environment = "landingzone"
  }

  metadata = {
    Terraform   = "true"
    Environment = "landingzone"
  }

  depends_on = [
    module.keypair, module.sg_firewall, module.network_vpc
  ]
}

