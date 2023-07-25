# Provision KMS key for preprod tenant
module "kms_key_preprod" {
  providers = {
    flexibleengine = flexibleengine.preprod_fe
  }

  source = "../modules/kms"

  key_alias       = "${var.kms_key_preprod.key_alias}_${random_string.id.result}"
  pending_days    = var.kms_key_preprod.pending_days
  key_description = var.kms_key_preprod.key_description
  realm           = var.kms_key_preprod.realm
  is_enabled      = var.kms_key_preprod.is_enabled
  rotation_enabled = var.kms_key_preprod.rotation_enabled
  rotation_interval = var.kms_key_preprod.rotation_interval
}

# Provision RSA KeyPair 
module "keypair_preprod" {
  source = "../modules/keypair"
  providers = {
    flexibleengine = flexibleengine.preprod_fe
  }
  keyname = var.keypair_preprod
}


# Provision PreProd Network VPC and Subnets
module "vpc_preprod" {
  providers = {
    flexibleengine = flexibleengine.preprod_fe
  }

  source = "../modules/vpc"

  vpc_name    = var.vpc_preprod.vpc_name
  vpc_cidr    = var.vpc_preprod.vpc_cidr
  vpc_subnets = var.vpc_preprod.vpc_subnets
}

// Create VPC Peering from PreProd to Transit VPC
module "peering_preprod" {
  source = "../modules/vpcpeering"

  providers = {
    flexibleengine.requester = flexibleengine.preprod_fe
    flexibleengine.accepter  = flexibleengine.network_fe
  }

  same_tenant   = var.peering_preprod.same_tenant
  tenant_acc_id = local.project_ids[var.network_tenant_name]

  peer_name     = var.peering_preprod.peer_name
  vpc_req_id = module.vpc_preprod.vpc_id
  vpc_acc_id = module.network_vpc.vpc_id
}