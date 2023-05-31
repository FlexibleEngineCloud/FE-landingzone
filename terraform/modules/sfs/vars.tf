// SFS variables
variable "sfs_shares" {
  description = "List of maps containing SFS Files systems"
  type = list(object({
    name      = string
    size      = string
    share_protocol    = optional(string)
    access_level    = optional(string)
    vpc_id    = optional(string)
    description = optional(string)

    kms_id    = optional(string)
    kms_domain_id    = optional(string)
    kms_key_alias = optional(string)
  }))
  default = []
}