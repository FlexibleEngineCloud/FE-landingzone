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

# Tenant Names
variable "network_tenant_name" {
  type        = string
  description = "networking project name to login with"
  default = "eu-west-0_Netowrk2"
}
variable "security_tenant_name" {
  type        = string
  description = "security project name to login with"
  default = "eu-west-0_Security_Management2"
}
variable "database_tenant_name" {
  type        = string
  description = "database project name to login with"
  default = "eu-west-0_Database2"
}
variable "appdev_tenant_name" {
  type        = string
  description = "appdev project name to login with"
  default = "eu-west-0_App_Dev2"
}
variable "sharedservices_tenant_name" {
  type        = string
  description = "shared services project name to login with"
  default = "eu-west-0_Shared_Services2"
}
