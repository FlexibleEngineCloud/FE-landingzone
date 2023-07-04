# ECS Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_smn_topic_v2" "topic" {
  name         = var.topic_name
  display_name = var.topic_display_name
}

resource "flexibleengine_smn_subscription_v2" "subscriptions" {
  count = length(var.subscriptions)

  topic_urn = flexibleengine_smn_topic_v2.topic.id
  endpoint  = var.subscriptions[count.index].endpoint
  protocol  = var.subscriptions[count.index].protocol
  remark    = var.subscriptions[count.index].remark == null ? null : var.subscriptions[count.index].remark
  subscription_urn = var.subscriptions[count.index].subscription_urn == null ? null : var.subscriptions[count.index].subscription_urn
  owner = var.subscriptions[count.index].owner == null ? null : var.subscriptions[count.index].owner
  status = var.subscriptions[count.index].status == null ? null : var.subscriptions[count.index].status
}