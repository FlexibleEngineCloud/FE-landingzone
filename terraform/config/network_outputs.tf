// -------------------------- Transit outputs 
# Transit VPCs outputs
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
  value       = module.keypair.id
}

# EIP outputs
output "firewall_public_ips" {
  description = "firewall Elastic IP Addresses"
  value       = module.firewall_eip.public_ips
}

output "firewall_eip_ids" {
  description = "firewall Elastic IP IDs"
  value       = module.firewall_eip.ids
}


# AntiDDOS outputs
output "public_ips_antiddos" {
  description = "AntiDDOS IDs attached to firewall EIPs"
  value       = module.antiddos.ids
}


# Inbound Virtual IP outputs
output "vip_in_id" {
  description = "The inbound Virtual IP ID"
  value       = module.network_vip_in.id
}

output "vip_in_ip_address" {
  description = "The IP address in the subnet for the inbound vip"
  value       = module.network_vip_in.ip_address
}

# Outbound Virtual IP outputs
output "vip_out_id" {
  description = "The oubound Virtual IP ID"
  value       = module.network_vip_in.id
}

output "vip_out_ip_address" {
  description = "The IP address in the subnet for the outbound vip"
  value       = module.network_vip_in.ip_address
}

# Firewall instances outputs
output "firewalls_network" {
  description = "Network block of the provisioned ECS instance"
  value       = module.ecs_cluster.network
}

output "firewalls_id" {
  value       = module.ecs_cluster.id
  description = "The ID of the provisioned ECS instances"
}


// -------------------------- DMZ outputs 
# DMZ VPCs outputs
output "dmz_vpc_id" {
  value = module.network_vpc_dmz.vpc_id
}

output "dmz_vpc_name" {
  value = module.network_vpc_dmz.vpc_name
}

output "dmz_subnet_ids" {
  value = module.network_vpc_dmz.subnet_ids
}

output "dmz_network_ids" {
  value = module.network_vpc_dmz.network_ids
}

# VPC Peering outputs
output "dmz_peering_id" {
  description = "ID of the created peering between Transit and DMZ"
  value       = module.peering_dmz.id
}