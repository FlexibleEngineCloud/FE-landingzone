# ECS Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_ces_alarmrule" "alarm_rules" {
  count = length(var.alarm_rules)

  alarm_name = var.alarm_rules[count.index].alarm_name

  dynamic "metric" {
    for_each = var.alarm_rules[count.index].metric
    content {
      namespace   = metric.value.namespace
      metric_name = metric.value.metric_name

      dynamic "dimensions" {
        for_each = metric.value.dimensions
        content {
          name  = dimensions.value.name
          value = dimensions.value.value
        }
      }
    }
  }

  dynamic "condition" {
    for_each = var.alarm_rules[count.index].condition
    content {
      period              = condition.value.period
      filter              = condition.value.filter
      comparison_operator = condition.value.comparison_operator
      value               = condition.value.value
      unit                = condition.value.unit
      count               = condition.value.count
    }
  }

  dynamic "alarm_actions" {
    for_each = var.alarm_rules[count.index].alarm_actions == null ? [] : var.alarm_rules[count.index].alarm_actions
    content {
      type              = alarm_actions.value.type
      notification_list = alarm_actions.value.notification_list
    }
  }

  dynamic "ok_actions" {
    for_each = var.alarm_rules[count.index].ok_actions == null ? [] :  var.alarm_rules[count.index].ok_actions
    content {
      type              = ok_actions.value.type
      notification_list = ok_actions.value.notification_list
    }
  }
}