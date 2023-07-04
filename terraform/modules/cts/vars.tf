// SMN vars

variable "topic_name" {
  description = "Topic name"
  type        = string
}

variable "topic_display_name" {
  description = "Topic display name"
  type        = string
  default     = null
}

variable "subscriptions" {
  description = "SMN Subscriptions"
  type = list(object({
    endpoint         = string
    protocol         = string
    remark           = optional(string)
    subscription_urn = optional(string)
    owner            = optional(string)
    status           = optional(string)
  }))
}
