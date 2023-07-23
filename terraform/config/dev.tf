# Provision KMS key for dev tenant
module "kms_key_dev" {
  providers = {
    flexibleengine = flexibleengine.dev_fe
  }

  source = "../modules/kms"

  key_alias       = "kms_key_dev_${random_string.id.result}"
  pending_days    = "7"
  key_description = "KMS key for dev project"
  realm           = "eu-west-0"
  is_enabled      = true
  rotation_enabled = true
  rotation_interval = 100
}

# Provision RSA KeyPair 
module "keypair_dev" {
  source = "../modules/keypair"
  providers = {
    flexibleengine = flexibleengine.dev_fe
  }
  keyname = "TF-KeyPair-dev"
}


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
  tenant_acc_id = local.project_ids[var.network_tenant_name]

  peer_name = "peering-transit-dev"
  vpc_req_id = module.vpc_dev.vpc_id
  vpc_acc_id = module.network_vpc.vpc_id
}