// RDS outputs
output "rds_nodes" {
  description = "List of RDS nodes"
  value       =  module.rds_appdev.nodes
}

output "rds_id" {
  description = "RDS Instance id"
  value       = module.rds_appdev.id
}

output "rds_private_ips" {
  description = "RDS Private IP address list of nodes"
  value       = module.rds_appdev.private_ips
}

output "rds_public_ips" {
  description = "RDS Public IP address list of nodes"
  value       = module.rds_appdev.public_ips
}
