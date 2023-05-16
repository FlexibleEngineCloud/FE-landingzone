output "id" {
  description = "The Load Balancer ID"
  value       = flexibleengine_lb_loadbalancer_v3.loadbalancer.id
}

output "listeners" {
  description = "The LB listeners"
  value       = [for listener in flexibleengine_lb_listener_v3.listeners : listener ]
}

output "pools" {
  description = "The LB pools"
  value       = [for pool in flexibleengine_lb_pool_v3.pools : pool ]
}

output "members" {
  description = "The LB members"
  value       = [for member in flexibleengine_lb_member_v3.members : member ]
}

output "monitors" {
  description = "The LB monitors"
  value       = [for monitor in flexibleengine_lb_monitor_v3.monitors : monitor ]
}