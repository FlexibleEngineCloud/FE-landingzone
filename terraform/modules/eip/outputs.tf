output "public_ip" {
  description = "firewall Elastic IP Address"
  value       = flexibleengine_vpc_eip_v1.eip_protected[0].publicip
}

output "id" {
  description = "firewall Elastic IP ID"
  value       = flexibleengine_vpc_eip_v1.eip_protected[0].id
}
