# Provider variables
variable "ak" {
  type        = string
  description = "The access key of the FlexibleEngine cloud"
  sensitive   = true
}
variable "sk" {
  type        = string
  description = "The secret key of the FlexibleEngine cloud"
  sensitive   = true
}
variable "domain_name" {
  type        = string
  description = "The Name of the Domain to scope to"
}
variable "tenant_name" {
  type        = string
  description = "The Name of the Project to login with"
}
variable "region" {
  type        = string
  description = "Region of the FlexibleEngine cloud"
  default     = "eu-west-0"
}
