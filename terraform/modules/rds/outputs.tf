output "nodes" {
  description = "List of RDS nodes"
  value       = flexibleengine_rds_instance_v3.instance.nodes
}

output "id" {
  description = "Instance id"
  value       = flexibleengine_rds_instance_v3.instance.id
}

output "private_ips" {
  description = "Private IP address list of nodes"
  value       = flexibleengine_rds_instance_v3.instance.private_ips
}

output "public_ips" {
  description = "Public IP address list of nodes"
  value       = flexibleengine_rds_instance_v3.instance.public_ips
}