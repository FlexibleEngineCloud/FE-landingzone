# VPC ID as output
output "vpc_id" {
  value = module.network_vpc.vpc_id
}

# VPC name as output
output "vpc_name" {
  value = module.network_vpc.vpc_name
}

# Subnet IDs as output
output "subnet_ids" {
  value = module.network_vpc.subnet_ids
}

# Network IDs as output
output "network_ids" {
  value = module.network_vpc.network_ids
}