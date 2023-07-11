
# Provision DMZ Network VPC and Subnets
module "network_vpc_dmz" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/vpc"

  vpc_name = "vpc-dmz"
  vpc_cidr = "192.169.0.0/16"
  vpc_subnets = [{
    subnet_cidr       = "192.169.1.0/24"
    subnet_gateway_ip = "192.169.1.1"
    subnet_name       = "subnet-dmz"
    }
  ]
}


// Create VPC Peering from DMZ to Transit VPC
module "peering_dmz" {
  source = "../modules/vpcpeering"

  providers = {
    flexibleengine.requester = flexibleengine.network_fe
    flexibleengine.accepter  = flexibleengine.network_fe
  }

  same_tenant = true
  // making same_tenant true, no flexibleengine_vpc_peering_connection_accepter_v2 resource created 

  peer_name = "peering-transit-dmz"
  vpc_req_id = module.network_vpc_dmz.vpc_id
  vpc_acc_id = module.network_vpc.vpc_id
}

