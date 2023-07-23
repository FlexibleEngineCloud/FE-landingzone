// -------------------------- PreProd outputs 
# KMS project preprod outptus
output "preprod_kms_id" {
    value       = module.kms_key_preprod.id
    description = "The globally unique identifier for the KMS key preprod project"
}

output "preprod_kms_attributes" {
    value       = module.kms_key_preprod.key
    description = "KMS preprod attributes"
}

# KeyPair outputs
output "preprod_keypair_id" {
    value       = module.keypair_preprod.id
    description = "The ID of the KeyPair preprod"
}

output "preprod_keypair_name" {
    value       = module.keypair_preprod.name
    description = "The name of the keypair preprod"
}

# PreProd VPC outputs
output "preprod_vpc_id" {
  value = module.vpc_preprod.vpc_id
}

output "preprod_vpc_name" {
  value = module.vpc_preprod.vpc_name
}

output "preprod_subnet_ids" {
  value = module.vpc_preprod.subnet_ids
}

output "preprod_network_ids" {
  value = module.vpc_preprod.network_ids
}

# PreProd VPC Peering outputs
output "preprod_peering_id" {
  description = "ID of the created peering between Transit and PreProd"
  value       = module.peering_preprod.id
}