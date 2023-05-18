output "vpc_id" {
  description = "ID of the created vpc"
  value       = flexibleengine_vpc_v1.vpc.id
}

output "vpc_name" {
  description = "Name of the created vpc"
  value       = flexibleengine_vpc_v1.vpc.name
}

output "subnet_names" {
  description = "Name of the created vpc"
  value       = [for subnet in flexibleengine_vpc_subnet_v1.vpc_subnets : subnet.name ]  
}

output "subnet_ids" {
  description = "list of IDs of the created subnets"
  value       = [for subnet in flexibleengine_vpc_subnet_v1.vpc_subnets : subnet.subnet_id]
}

output "network_ids" {
  description = "list of IDs of the created networks"
  value       = [for subnet in flexibleengine_vpc_subnet_v1.vpc_subnets : subnet.id]
}