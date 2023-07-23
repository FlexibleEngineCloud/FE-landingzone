# Provision DMZ Network VPC and Subnets
module "network_vpc_dmz" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/vpc"

  vpc_name    = var.network_vpc_dmz.vpc_name
  vpc_cidr    = var.network_vpc_dmz.vpc_cidr
  vpc_subnets = var.network_vpc_dmz.vpc_subnets
}


// Create VPC Peering from DMZ to Transit VPC
module "peering_dmz" {
  source = "../modules/vpcpeering"

  providers = {
    flexibleengine.requester = flexibleengine.network_fe
    flexibleengine.accepter  = flexibleengine.network_fe
  }

  same_tenant = var.peering_dmz.same_tenant
  // making same_tenant true, no flexibleengine_vpc_peering_connection_accepter_v2 resource created 

  peer_name   = var.peering_dmz.peer_name
  vpc_req_id = module.network_vpc_dmz.vpc_id
  vpc_acc_id = module.network_vpc.vpc_id
}