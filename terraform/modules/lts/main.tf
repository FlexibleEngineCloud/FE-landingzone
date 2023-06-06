# ECS Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_ces_alarmrule" "alarm_rule" {
  alarm_name = "alarm_rule"

  metric {
    namespace   = "SYS.ECS"
    metric_name = "network_outgoing_bytes_rate_inband"
    dimensions {
        name  = "instance_id"
        value = var.instance_id
    }
  }
  condition  {
    period              = 300
    filter              = "average"
    comparison_operator = ">"
    value               = 6
    unit                = "B/s"
    count               = 1
  }
  alarm_actions {
    type = "notification"
    notification_list = [
      var.topic_id
    ]
  }
}