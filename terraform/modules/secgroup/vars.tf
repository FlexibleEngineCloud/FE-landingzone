variable "name" {
  description = "The security group name"
  type        = string
}

variable "description" {
  description = "The security group description"
  default     = "Security Group managed by Terraform"
  type        = string
}

variable "delete_default_egress_rules" {
  description = "Wheter or not create default egress rules (allow all protocols to any destination)"
  default     = false
}

variable "ingress_with_source_cidr" {
  description = "List of ingress rules to create where a CIDR is remote"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    ethertype   = string
    source_cidr = string
  }))
  default = []
}
