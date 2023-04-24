output "network" {
  description = "Network block of the provisioned ECS instance"
  value       = [for instance in flexibleengine_compute_instance_v2.instances : instance.network] 
}

output "id" {
    value       = [for instance in flexibleengine_compute_instance_v2.instances : instance.id] 
    description = "The ID of the provisioned ECS instances"
}