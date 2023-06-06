// CES Alarm rules vars
variable "alarm_rules" {
  description = "CES Alarm rules list"
  type = list(object({
    alarm_name           = string
    alarm_description    = optional(string)
    alarm_enabled        = optional(bool)
    alarm_level          = optional(number)
    alarm_action_enabled = optional(bool)

    metric = list(object({
      namespace   = string
      metric_name = string
      dimensions = list(object({
        name  = string
        value = string
      }))
    }))
    condition = list(object({
      period              = number
      filter              = string
      comparison_operator = string
      value               = number
      unit                = optional(string)
      count               = optional(number)
    }))

    alarm_actions = optional(list(object({
      type              = optional(string)
      notification_list              = optional(list(string))
    })))

    ok_actions = optional(list(object({
      type              = optional(string)
      notification_list  = optional(list(string))
    })))

  }))
}
