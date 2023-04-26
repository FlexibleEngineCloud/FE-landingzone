variable "name" {
  type = string
  description = "Tha neame of the agency to be created"
}

variable "delegated_service_name" {
  type = string
  description = "Delegated service name to apply role permissions"
  default = ""
}

variable "delegated_domain_name" {
  type = string
  description = "Delegated domain name to apply role permissions, if delegated_domain_name used, delegated_service_name must not be setted"
  default = ""
}

variable "tenant_name" {
  type = string
  description = "Tenant name on which you apply role permissions"
}

variable "roles" {
  type = list(string)
  description = "List of roles names to be applied"
}

variable "domain_roles" {
  type = list(string)
  description = "List of domain roles names to be applied"
  default = [""]
}

variable "duration" {
  type = string
  description = "Specify the duration of validity of the agency, two accepted values 'ONEDAY' and 'FOREVER' "
  default = "FOREVER"
}