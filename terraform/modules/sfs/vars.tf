// SFS variables
variable "sfs_shares" {
  description = "List of maps containing SFS Files systems"
  type = list(object({
    name      = optional(string)
    size      = number
    share_protocol    = optional(string)
    access_level    = optional(string)
    vpc_id    = optional(string)
    description = optional(string)

    kms_id    = optional(string)
    kms_domain_id    = optional(string)
    kms_key_alias = optional(string)

    access_to = optional(string)
    access_type = optional(string)
    access_level = optional(string)
  }))
  default = []
}

// SFS Turbo variables
variable "sfs_turbos" {
  description = "List of maps containing SFS Turbo Files systems"
  type = list(object({
    name      = string
    size      = number
    availability_zone  = string
    security_group_id  = string
    vpc_id     = string
    subnet_id    = string
    /*
    share_protocol    = optional(string)
    share_type    = optional(string)
    kms_id    = optional(string)
    */
  }))
  default = []
}