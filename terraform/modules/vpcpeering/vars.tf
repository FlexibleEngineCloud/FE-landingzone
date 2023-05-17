variable "peer_name" {
  description = "Name of the peering connection"
  type = string
}

variable "tenant_acc_id" {
  description = "tenant ID of the accepter"
  type = string
  default     = null
}

variable "vpc_req_name" {
  description = "Name of the requester's VPC"
  type = string
  default     = null
}

variable "vpc_req_id" {
  description = "ID of the requester's VPC"
  type = string
  default     = null
}

variable "vpc_acc_name" {
  description = "Name of accepter's VPC"
  type = string
  default     = null
}

variable "vpc_acc_id" {
  description = "ID of accepter's VPC"
  type = string
  default     = null
}

variable "same_tenant" {
  description = "Indicates VPC are in the same tenant"
  type = bool
  default     = true
}