output "topic" {
  description = "Topic object"
  value       = flexibleengine_smn_topic_v2.topic
}

output "subscriptions" {
  description = "Subscriptions objects"
  value       = [for subscription in flexibleengine_smn_subscription_v2.subscriptions : subscription ]
}

output "subscription_urns" {
  description = "Subscriptions URNs"
  value       = [for subscription in flexibleengine_smn_subscription_v2.subscriptions : subscription.subscription_urn ]
}