output "firewall1_in" {
  value = flexibleengine_compute_instance_v2.firewall1.network.0.fixed_ip_v4
}
output "firewall1_out" {
  value = flexibleengine_compute_instance_v2.firewall1.network.1.fixed_ip_v4
}
output "firewall2_in" {
  value = flexibleengine_compute_instance_v2.firewall2.network.0.fixed_ip_v4
}
output "firewall2_out" {
  value = flexibleengine_compute_instance_v2.firewall2.network.1.fixed_ip_v4
}
output "vip_in" {
  value = flexibleengine_networking_vip_v2.vip_in.ip_address
}
output "vip_out" {
  value = flexibleengine_networking_vip_v2.vip_out.ip_address
}