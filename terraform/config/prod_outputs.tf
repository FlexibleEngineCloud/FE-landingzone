// -------------------------- Prod outputs 
# Prod VPC outputs
output "prod_vpc_id" {
  value = module.vpc_prod.vpc_id
}

output "prod_vpc_name" {
  value = module.vpc_prod.vpc_name
}

output "prod_subnet_ids" {
  value = module.vpc_prod.subnet_ids
}

output "prod_network_ids" {
  value = module.vpc_prod.network_ids
}

# Prod Security Group outputs
output "prod_secgroup_id" {
  description = "The ID of the prod security group"
  value       = module.sg_prod.id
}

output "prod_secgroup_name" {
  description = "The name of the prod security group"
  value       = module.sg_prod.name
}

/*
// Prod RDS outputs
output "rds_nodes" {
  description = "List of RDS nodes"
  value       =  module.rds_prod_ha.nodes
}

output "rds_id" {
  description = "RDS Instance id"
  value       = module.rds_prod_ha.id
}

output "rds_private_ips" {
  description = "RDS Private IP address list of nodes"
  value       = module.rds_prod_ha.private_ips
}

output "rds_public_ips" {
  description = "RDS Public IP address list of nodes"
  value       = module.rds_prod_ha.public_ips
}
*/

/*
// OBS outputs
output "bucket_id" {
  description = "The name of the bucket."
  value       = module.obs_prod_bucket_adv.id
}

output "bucket_domain_name" {
  description = "The bucket domain name. Will be of format <bucket-name>.oss.<region>.prod-cloud-ocb.orange-business.com."
  value       = module.obs_prod_bucket_adv.domain_name
}

output "bucket_region" {
  description = "The Flexible Engine region this bucket resides in."
  value       = module.obs_prod_bucket_adv.region
}

output "bucket_objects" {
  description = "The Flexible Engine bucket objects"
  value       = module.obs_prod_bucket_adv.bucket_objects
}
*/

/*
// KMS outputs
output "kms_id" {
    value       = module.kms_key.id
    description = "The globally unique identifier for the key"
}

output "kms_attributes" {
    value       = module.kms_key.key
    description = "KMS attributes"
}


// S3 outputs
output "s3bucket_id" {
  description = "The name of the bucket."
  value       = module.s3_prod_bucket_adv.id
}

output "s3bucket_domain_name" {
  description = "The bucket domain name. Will be of format <bucket-name>.oss.<region>.prod-cloud-ocb.orange-business.com."
  value       = module.s3_prod_bucket_adv.domain_name
}

output "s3bucket_region" {
  description = "The Flexible Engine region this bucket resides in."
  value       = module.s3_prod_bucket_adv.region
}

output "s3bucket_objects" {
  description = "The Flexible Engine bucket objects"
  value       = module.s3_prod_bucket_adv.bucket_objects
}
*/

// SFS outputs
// SFS file systems shares outputs
output "sfs_ids" {
  description = "SFS shares IDs"
  value       = module.sfs_file_systems.sfs_ids 
}
output "sfs" {
  description = "SFS shares detailed"
  value       = module.sfs_file_systems.sfs
}

// SFS Turbo outputs
output "sfs_turbo_ids" {
  description = "SFS Turbo IDs"
  value       = module.sfs_file_systems.sfs_turbo_ids
}
output "sfs_turbos" {
  description = "SFS Turbo detailed"
  value       = module.sfs_file_systems.sfs_turbos
}