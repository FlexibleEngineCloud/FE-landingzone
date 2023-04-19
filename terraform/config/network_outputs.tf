# VPCs outputs
output "vpc_id" {
  value = module.network_vpc.vpc_id
}

output "vpc_name" {
  value = module.network_vpc.vpc_name
}

output "subnet_ids" {
  value = module.network_vpc.subnet_ids
}

output "network_ids" {
  value = module.network_vpc.network_ids
}

# Security Group outputs
output "secgroup_id" {
  description = "The ID of the security group"
  value       = module.sg_firewall.id
}

output "secgroup_name" {
  description = "The name of the security group"
  value       = module.sg_firewall.name
}

# KeyPair outputs
output "keypair_id" {
  description = "The ID of the KeyPair"
  value       =  module.keypair.id
}

# EIP outputs
output "firewall_public_ip" {
  description = "firewall Elastic IP Address"
  value       = module.firewall_eip.public_ip
}

output "firewall_eip_id" {
  description = "firewall Elastic IP ID"
  value       = module.firewall_eip.id
}

# Firewall instances outputs

