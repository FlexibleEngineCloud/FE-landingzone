output "id" {
  description = "The Load Balancer ID"
  value       = flexibleengine_lb_loadbalancer_v2.loadbalancer.id
}

output "private_ip" {
  description = "The LB private IP"
  value       = flexibleengine_lb_loadbalancer_v2.loadbalancer.vip_address
}

output "pools" {
  description = "The LB pools"
  value       = [for pool in flexibleengine_lb_pool_v2.pools : { id = pool.id, name = pool.name }]
}