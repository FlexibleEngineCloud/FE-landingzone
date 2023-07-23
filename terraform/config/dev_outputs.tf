// -------------------------- Dev outputs 
# KMS project dev outptus
output "dev_kms_id" {
    value       = module.kms_key_dev.id
    description = "The globally unique identifier for the KMS key dev project"
}

output "dev_kms_attributes" {
    value       = module.kms_key_dev.key
    description = "KMS dev attributes"
}

# KeyPair outputs
output "dev_keypair_id" {
    value       = module.keypair_dev.id
    description = "The ID of the KeyPair dev"
}

output "dev_keypair_name" {
    value       = module.keypair_dev.name
    description = "The name of the keypair dev"
}

# Dev VPC outputs
output "dev_vpc_id" {
  value = module.vpc_dev.vpc_id
}

output "dev_vpc_name" {
  value = module.vpc_dev.vpc_name
}

output "dev_subnet_ids" {
  value = module.vpc_dev.subnet_ids
}

output "dev_network_ids" {
  value = module.vpc_dev.network_ids
}

# Dev VPC Peering outputs
output "dev_peering_id" {
  description = "ID of the created peering between Transit and Dev"
  value       = module.peering_dev.id
}