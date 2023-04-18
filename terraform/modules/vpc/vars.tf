# VPC name variable
variable "vpc_name" {
  description = "Name of the VPC to create"
  type        = string
}

# VPC CIDR variable
variable "vpc_cidr" {
  description = "The CIDR for the VPC"
  type        = string
}

# VPC Subnets variable
variable "vpc_subnets" {
  description = "json description of subnets to create"
  default     = []
  type = list(object({
    subnet_name       = string
    subnet_cidr       = string
    subnet_gateway_ip = string
  }))
}

# VPC primary DNS
variable "primary_dns" {
  description = "IP address of primary DNS"
  default     = "100.125.0.41"
  type        = string
}

# VPC secondary DNS
variable "secondary_dns" {
  description = "IP address of secondary DNS"
  default     = "100.125.12.161"
  type        = string
}
