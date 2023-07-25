# Provision KMS key for dev tenant
module "kms_key_dev" {
  providers = {
    flexibleengine = flexibleengine.dev_fe
  }

  source = "../modules/kms"

  key_alias       = "${var.kms_key_dev.key_alias}_${random_string.id.result}"
  pending_days    = var.kms_key_dev.pending_days
  key_description = var.kms_key_dev.key_description
  realm           = var.kms_key_dev.realm
  is_enabled      = var.kms_key_dev.is_enabled
  rotation_enabled = var.kms_key_dev.rotation_enabled
  rotation_interval = var.kms_key_dev.rotation_interval
}

# Provision RSA KeyPair 
module "keypair_dev" {
  source = "../modules/keypair"
  providers = {
    flexibleengine = flexibleengine.dev_fe
  }
  keyname = var.keypair_dev
}


# Provision Dev Network VPC and Subnets
module "vpc_dev" {
  providers = {
    flexibleengine = flexibleengine.dev_fe
  }

  source = "../modules/vpc"

  vpc_name    = var.vpc_dev.vpc_name
  vpc_cidr    = var.vpc_dev.vpc_cidr
  vpc_subnets = var.vpc_dev.vpc_subnets
}

// Create VPC Peering from Dev to Transit VPC
module "peering_dev" {
  source = "../modules/vpcpeering"

  providers = {
    flexibleengine.requester = flexibleengine.dev_fe
    flexibleengine.accepter  = flexibleengine.network_fe
  }

  same_tenant   = var.peering_dev.same_tenant
  tenant_acc_id = local.project_ids[var.network_tenant_name]

  peer_name     = var.peering_dev.peer_name
  vpc_req_id = module.vpc_dev.vpc_id
  vpc_acc_id = module.network_vpc.vpc_id
}