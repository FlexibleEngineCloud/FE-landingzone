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
