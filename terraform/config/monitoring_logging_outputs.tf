// TMS outputs

// OBS CTS Bucket IDs for tenants
output "cts_network_bucket_id" {
  description = "Bucket ID of CTS network tenant tracker"
  value       = module.obs_cts_bucket_network.id
}
output "cts_dev_bucket_id" {
  description = "Bucket ID of CTS dev tenant tracker"
  value       = module.obs_cts_bucket_dev.id
}
output "cts_preprod_bucket_id" {
  description = "Bucket ID of CTS preprod tenant tracker"
  value       = module.obs_cts_bucket_preprod.id
}
output "cts_prod_bucket_id" {
  description = "Bucket ID of CTS prod tenant tracker"
  value       = module.obs_cts_bucket_prod.id
}
output "cts_shared_bucket_id" {
  description = "Bucket ID of CTS shared services tenant tracker"
  value       = module.obs_cts_bucket_shared.id
}

// CTS OBS IAM Policy


// CTS outputs


// LTS Group IDs
output "lts_prod_group_id" {
  description = "The ID of LTS Group"
  value       = flexibleengine_lts_group.lts_prod_hosts_group.id
}
output "lts_preprod_group_id" {
  description = "The ID of LTS Group"
  value       = flexibleengine_lts_group.lts_preprod_hosts_group.id
}
output "lts_dev_group_id" {
  description = "The ID of LTS Group"
  value       = flexibleengine_lts_group.lts_dev_hosts_group.id
}
output "lts_network_group_id" {
  description = "The ID of LTS Group"
  value       = flexibleengine_lts_group.lts_network_hosts_group.id
}
output "lts_shared_group_id" {
  description = "The ID of LTS Group"
  value       = flexibleengine_lts_group.lts_shared_hosts_group.id
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
output "lts_transit_topic_id" {
  description = "The ID of LTS Transit Topic"
  value       = flexibleengine_lts_topic.lts_transit_hosts_topic.id
}
output "lts_shared_topic_id" {
  description = "The ID of LTS Shared Topic"
  value       = flexibleengine_lts_topic.lts_shared_hosts_topic.id
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

// CES Rules outputs
