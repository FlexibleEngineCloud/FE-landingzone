variable "vip_name" {
  type = string
  description = "Virtual IP name"
}

variable "ip_address" {
  type = string
  description = "Virtual IP address"
}

variable "ip_version" {
  type = number
  default = 4
  description = "Virtual IP address type, either 4 for IPV4 or 6 for IPV6"
}

variable "subnet_id" {
  type = string
  description = "Specifies the ID of the VPC Subnet to which the VIP belongs"
}

variable "port_ids" {
  type = list(string)
  description = "An array of one or more IDs of the ports to attach the vip to"
}