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
  ip_address = "192.168.1.100"
  subnet_id  = module.network_vpc.network_ids[0]
  port_ids   = [for instance_network in module.ecs_cluster.network : instance_network.0.port]
}

# Provision Virtual outbound IP
module "network_vip_out" {
  source = "../modules/vip"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  vip_name   = "outbound-vip"
  ip_address = "192.168.2.100"
  subnet_id  = module.network_vpc.network_ids[1]
  port_ids   = [for instance_network in module.ecs_cluster.network : instance_network.1.port]
}


# Provision Public IP
module "firewall_eip" {
  source = "../modules/eip"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  eip_count     = 3
  eip_name      = "external-eip"
  eip_bandwidth = 1000
  protect_eip   = true
}

# Assign AntiDDOS
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
