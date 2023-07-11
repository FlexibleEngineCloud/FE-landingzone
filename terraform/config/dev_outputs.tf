// -------------------------- Dev outputs 
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