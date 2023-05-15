output "id" {
  description = "The Load Balancer ID"
  value       = flexibleengine_lb_loadbalancer_v3.loadbalancer.id
}

output "pools" {
  description = "The LB pools"
  value       = [for pool in flexibleengine_lb_pool_v3.pools : { id = pool.id, name = pool.name }]
}