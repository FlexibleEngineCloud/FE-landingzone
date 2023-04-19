output "id" {
  description = "The ID of the security group"
  value       = flexibleengine_networking_secgroup_v2.secgroup.id
}

output "name" {
  description = "The name of the security group"
  value       = flexibleengine_networking_secgroup_v2.secgroup.name
}
