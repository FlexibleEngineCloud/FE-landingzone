output "id" {
  description = "The Virtual IP ID"
  value       = flexibleengine_networking_vip_associate_v2.vip_associate.id
}

output "ip_address" {
  description = "The IP address in the subnet for the vip"
  value       = flexibleengine_networking_vip_associate_v2.vip_associate.vip_ip_address
}