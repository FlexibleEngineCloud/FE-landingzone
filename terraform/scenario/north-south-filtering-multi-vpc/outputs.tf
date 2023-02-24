output "ip_firewall_in" {
  value = flexibleengine_compute_instance_v2.firewall.network.0.fixed_ip_v4
}
output "ip_firewall_out" {
  value = flexibleengine_compute_instance_v2.firewall.network.1.fixed_ip_v4
}