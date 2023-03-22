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
}


variable "cidr_remote_vpc" {
  type        = string
  description = "Specifies the remote VPC CIDR"
}
variable "cidr_subnet_remote" {
  type        = string
  description = "Specifies the remote subnet CIDR"
}
variable "remote_gateway" {
  type        = string
  description = "Gateway of the remote subnet"
}

variable "tag" {
  type        = string
  description = "Tagging resources"
}