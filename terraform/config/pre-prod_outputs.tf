// -------------------------- PreProd outputs 
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