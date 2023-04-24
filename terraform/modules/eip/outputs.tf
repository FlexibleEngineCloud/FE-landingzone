output "public_ips" {
  description = "firewall Elastic IP Addresses"
  value       = [for eip in flexibleengine_vpc_eip.eip_protected : eip.publicip]
}

output "ids" {
  description = "firewall Elastic IP IDs"
  value       = [for eip in flexibleengine_vpc_eip.eip_protected : eip.id]
}
