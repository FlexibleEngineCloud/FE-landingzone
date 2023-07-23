# Provision KMS key for preprod tenant
module "kms_key_preprod" {
  providers = {
    flexibleengine = flexibleengine.preprod_fe
  }

  source = "../modules/kms"

  key_alias       = "kms_key_preprod_${random_string.id.result}"
  pending_days    = "7"
  key_description = "KMS key for preprod project"
  realm           = "eu-west-0"
  is_enabled      = true
  rotation_enabled = true
  rotation_interval = 100
}

# Provision RSA KeyPair 
module "keypair_preprod" {
  source = "../modules/keypair"
  providers = {
    flexibleengine = flexibleengine.preprod_fe
  }
  keyname = "TF-KeyPair-preprod"
}


# Provision PreProd Network VPC and Subnets
module "vpc_preprod" {
  providers = {
    flexibleengine = flexibleengine.preprod_fe
  }

  source = "../modules/vpc"

  vpc_name = "vpc-preprod"
  vpc_cidr = "192.168.5.0/24"
  vpc_subnets = [{
    subnet_cidr       = "192.168.5.0/27"
    subnet_gateway_ip = "192.168.5.1"
    subnet_name       = "subnet-preprod"
    }
  ]
}

// Create VPC Peering from PreProd to Transit VPC
module "peering_preprod" {
  source = "../modules/vpcpeering"

  providers = {
    flexibleengine.requester = flexibleengine.preprod_fe
    flexibleengine.accepter  = flexibleengine.network_fe
  }

  same_tenant = false
  tenant_acc_id = local.project_ids[var.network_tenant_name]

  peer_name = "peering-transit-preprod"
  vpc_req_id = module.vpc_preprod.vpc_id
  vpc_acc_id = module.network_vpc.vpc_id
}