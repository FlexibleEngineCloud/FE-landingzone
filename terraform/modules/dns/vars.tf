variable "zones" {
  type = list(object({
    name        = string
    description = optional(string)
    email       = optional(string)
    ttl         = optional(number)
    zone_type   = optional(string)
    //value_specs = optional(string)

    domain_name = string

    router_id     = optional(string)
    router_region = optional(string)

    dns_recordsets = list(object({
      name        = optional(string)
      description = optional(string)
      ttl         = optional(number)
      type        = string
      records     = list(string)
      value_specs = optional(map(string))
    }))
  }))
  default = []
}
