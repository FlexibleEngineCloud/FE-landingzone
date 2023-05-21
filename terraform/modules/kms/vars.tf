variable "key_alias" {
  description = "Specifies the name of a KMS key."
  type        = string
}

variable "pending_days" {
  description = "Specifies the duration in days after which the key is deleted after destruction of the resource, must be between 7 and 1096 days"
  default     = null
  type        = number
}

variable "key_description" {
  description = "Specifies the description of a KMS key"
  type        = string
  default     = null
}

variable "realm" {
  description = "Region where a key resides"
  type        = string
  default     = null
}

variable "is_enabled" {
  description = "A list of security group names to associate with"
  type        = bool
  default     = null
}

variable "rotation_enabled" {
  description = "Specifies whether the key rotation is enabled. "
  type        = bool
  default     = null
}

variable "rotation_interval" {
  description = "Specifies the key rotation interval. The valid value is range from 30 to 365"
  type        = number
  default     = null
}