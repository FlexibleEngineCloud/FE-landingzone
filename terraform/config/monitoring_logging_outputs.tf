// OBS CTS Bucket ID
output "bucket_id" {
  description = "The name of the bucket."
  value       = module.obs_cts_bucket.id
}

// LTS Group ID
output "lts_group_id" {
  description = "The ID of LTS Group"
  value       = flexibleengine_lts_group.lts_hosts_group.id
}
// LTS Topic IDs
output "lts_prod_topic_id" {
  description = "The ID of LTS Prod Topic"
  value       = flexibleengine_lts_topic.lts_prod_hosts_topic.id
}
output "lts_dev_topic_id" {
  description = "The ID of LTS Dev Topic"
  value       = flexibleengine_lts_topic.lts_dev_hosts_topic.id
}
output "lts_dmz_topic_id" {
  description = "The ID of LTS DMZ Topic"
  value       = flexibleengine_lts_topic.lts_dmz_hosts_topic.id
}
output "lts_bastion_topic_id" {
  description = "The ID of LTS Bastion Topic"
  value       = flexibleengine_lts_topic.lts_bastion_hosts_topic.id
}