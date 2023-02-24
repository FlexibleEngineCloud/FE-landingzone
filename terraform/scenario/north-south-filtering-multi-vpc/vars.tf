# Provider variables
variable "ak" {
  type = string
  description = "The access key of the FlexibleEngine cloud"
  sensitive = true
}
variable "sk" {
  type = string
  description = "The secret key of the FlexibleEngine cloud"
  sensitive = true
}
variable "domain_name" {
  type = string
  description = "The Name of the Domain to scope to"
}
variable "tenant_name" {
  type = string
  description = "The Name of the Project to login with"
}
variable "region" {
  type = string
  description = "Region of the FlexibleEngine cloud"
}
variable "availability_zone_names" {
  type = list(string)
  description = "Availability zone of resource"
  default = ["eu-west-0a"]
}

# VPC and Subnet variables
variable "cidr_vpc" {
  type = string
  description = "Specifies the VPC CIDR"
}
variable "cidr_subnet_in" {
  type = string
  description = "Specifies the subnet CIDR"
}
variable "cidr_subnet_out" {
  type = string
  description = "Specifies the subnet CIDR"
}
variable "cidr_private_vpc" {
  type = string
  description = "Specifies the private VPC CIDR"
}
variable "cidr_private_subnet" {
  type = string
  description = "Specifies the private subnet CIDR"
}

variable "gateway_in" {
  type = string
  description = "Gateway of the subnet"
}
variable "gateway_out" {
  type = string
  description = "Gateway of the subnet"
}
variable "private_gateway" {
  type = string
  description = "Gateway of the private subnet"
}

# KeyPair Name
variable "generated_key_name" {
  type        = string
  default     = "TF-KeyPair"
  description = "Key-pair generated by Terraform"
}