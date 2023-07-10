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

/*
# ICAgenct agency outputs
output "icagenct_agency_id" {
  description = "ID of the created ICAgent agency"
  value       = module.icagent_agency.id
}
*/

// CES SMN outputs
output "ces_smn_topic" {
  description = "Topic object"
  value       = module.ces_smn.topic
}
output "ces_smn_subscriptions" {
  description = "Subscriptions objects"
  value       = module.ces_smn.subscriptions
}
output "ces_smn_subscription_urns" {
  description = "Subscriptions URNs"
  value       = module.ces_smn.subscription_urns
}
output "ces_smn_topic_urns" {
  description = "Topic URNs"
  value       = module.ces_smn.topic_urns
}