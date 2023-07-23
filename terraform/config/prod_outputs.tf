// -------------------------- Prod outputs 
# KMS project prod outptus
output "prod_kms_id" {
    value       = module.kms_key_prod.id
    description = "The globally unique identifier for the KMS key prod project"
}

output "prod_kms_attributes" {
    value       = module.kms_key_prod.key
    description = "KMS prod attributes"
}

# KeyPair outputs
output "prod_keypair_id" {
    value       = module.keypair_prod.id
    description = "The ID of the KeyPair prod"
}

output "prod_keypair_name" {
    value       = module.keypair_prod.name
    description = "The name of the keypair prod"
}

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

# VPC Peering outputs
output "prod_peering_id" {
  description = "ID of the created peering between Transit and Prod"
  value       = module.peering_prod.id
}

// -------
// Examples Deployments modules for diverse FE Resources to implement to the landing zone.
// Resources: RDS, CCE, ELB shared, ELB Dedicated, OBS, S3, DNS, SFS,... 
// Modules To Uncomment and Use as needed.
// Please don't forget to uncomment outputs as well. from prod_outputs.tf
// Could be implemented as well in dev/preprod tenants, or transit tenant.
// -------


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


/*
// DNS outputs


*/


/*
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
*/



/*
# CCE agency outputs
output "cce_agency_id" {
  description = "ID of the created CCE agency"
  value       = module.cce_agency.id
}

# CCE cluster outputs
output "cce_cluster_id" {
  description = "ID of the Cluster created"
  value       = module.cce_cluster.id
}

output "cce_nodes_list" {
  description = "List of nodes"
  value       = module.cce_cluster.nodes_list
}

output "cce_nodes_ip" {
  description = "List of nodes IP addresses"
  value       = module.cce_cluster.nodes_ip
}

output "cce_certificate_clusters" {
  value       = module.cce_cluster.certificate_clusters
  description = "CCE cluster certificates"
}

output "cce_certificate_users" {
  value       = module.cce_cluster.certificate_users
  description = "CCE user certificates"
}
*/


/*
// Shared load balancer outputs


*/


/*
// Dedicated Load balancer outputs
output "dedicated-lb-id" {
  description = "The Load Balancer ID"
  value       = module.dedicated-elb.id
}

output "dedicated-lb-listeners" {
  description = "The LB listeners"
  value       = module.dedicated-elb.listeners
}

output "dedicated-lb-pools" {
  description = "The LB pools"
  value       = module.dedicated-elb.pools
}

output "dedicated-lb-members" {
  description = "The LB members"
  value       = module.dedicated-elb.members
}

output "dedicated-lb-monitors" {
  description = "The LB monitors"
  value       = module.dedicated-elb.monitors
}
*/