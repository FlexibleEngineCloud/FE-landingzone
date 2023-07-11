# Provision Dev Network VPC and Subnets
module "vpc_dev" {
  providers = {
    flexibleengine = flexibleengine.dev_fe
  }

  source = "../modules/vpc"

  vpc_name = "vpc-dev"
  vpc_cidr = "192.168.4.0/24"
  vpc_subnets = [{
    subnet_cidr       = "192.168.4.0/27"
    subnet_gateway_ip = "192.168.4.1"
    subnet_name       = "subnet-dev"
    }
  ]
}

// Create VPC Peering from Dev to Transit VPC
module "peering_dev" {
  source = "../modules/vpcpeering"

  providers = {
    flexibleengine.requester = flexibleengine.dev_fe
    flexibleengine.accepter  = flexibleengine.network_fe
  }

  same_tenant = false
  // making same_tenant true, no flexibleengine_vpc_peering_connection_accepter_v2 resource created 

  peer_name = "peering-transit-dev"
  vpc_req_id = module.vpc_dev.vpc_id
  vpc_acc_id = module.network_vpc.vpc_id
}