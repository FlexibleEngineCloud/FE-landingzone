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


variable "availability_zones" {
  description = "A list of security group IDs to apply to the loadbalancer"
  type        = list(string)
  default = [
    "eu-west-0a",
    "eu-west-0b"
  ]
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
variable "dev_tenant_name" {
  type        = string
  description = "dev project name to login with"
  default = "eu-west-0_Dev2"
}
variable "preprod_tenant_name" {
  type        = string
  description = "preprod project name to login with"
  default = "eu-west-0_PreProd2"
}
variable "prod_tenant_name" {
  type        = string
  description = "prod project name to login with"
  default = "eu-west-0_Prod2"
}
variable "sharedservices_tenant_name" {
  type        = string
  description = "shared services project name to login with"
  default = "eu-west-0_Shared_Services2"
}

// ------------------------- Network variables
# Transit Network variables
variable "network_kms_key" {
  type = object({
    key_alias          = string
    pending_days       = string
    key_description    = string
    realm              = string
    is_enabled         = bool
    rotation_enabled   = bool
    rotation_interval  = number
  })

  default = {
    key_alias          = "kms_key_network"
    pending_days       = "7"
    key_description    = "KMS key for network project"
    realm              = "eu-west-0"
    is_enabled         = true
    rotation_enabled   = true
    rotation_interval  = 100
  }
}

variable "network_keypair" {
  type = string

  default = "TF-KeyPair-network"
}

variable "network_vpc" {
  type = object({
    vpc_name    = string
    vpc_cidr    = string
    vpc_subnets = list(object({
      subnet_cidr       = string
      subnet_gateway_ip = string
      subnet_name       = string
    }))
  })

  default = {
    vpc_name    = "network_vpc"
    vpc_cidr    = "192.168.0.0/16"
    vpc_subnets = [
      {
        subnet_cidr       = "192.168.1.0/24"
        subnet_gateway_ip = "192.168.1.1"
        subnet_name       = "subnet-in"
      },
      {
        subnet_cidr       = "192.168.2.0/24"
        subnet_gateway_ip = "192.168.2.1"
        subnet_name       = "subnet-out"
      },
      {
        subnet_cidr       = "192.168.3.0/24"
        subnet_gateway_ip = "192.168.3.1"
        subnet_name       = "subnet-sync"
      }
    ]
  }
}

variable "network_vips" {
  type = object({
    inbound  = string
    outbound = string
    inbound_vip_name  = string
    outbound_vip_name = string
  })

  default = {
    inbound  = "192.168.1.101"
    inbound_vip_name   = "inbound-vip"
    outbound = "192.168.2.101"
    outbound_vip_name   = "outbound-vip"
  }
}

variable "firewall_eip" {
  type = object({
    eip_name        = string
    eip_bandwidth   = number
    protect_eip     = bool
  })

  default = {
    eip_name        = "external-eip"
    eip_bandwidth   = 1000
    protect_eip     = true
  }
}

variable "antiddos" {
  type = object({
    enable_l7              = bool
    traffic_pos_id         = number
    http_request_pos_id    = number
    cleaning_access_pos_id = number
    app_type_id            = number
  })

  default = {
    enable_l7              = true
    traffic_pos_id         = 3
    http_request_pos_id    = 3
    cleaning_access_pos_id = 2
    app_type_id            = 1
  }
}

variable "sg_firewall" {
  type = object({
    name                        = string
    description                 = string
    delete_default_egress_rules = bool
    ingress_with_source_cidr    = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      ethertype   = string
      source_cidr = string
    }))
  })

  default = {
    name                        = "sg_firewall"
    description                 = "Security group for firewall instances"
    delete_default_egress_rules = false
    ingress_with_source_cidr = [
      {
        from_port   = 10
        to_port     = 1000
        protocol    = "tcp"
        ethertype   = "IPv4"
        source_cidr = "0.0.0.0/0"
      }
    ]
  }
}

variable "ecs_cluster" {
  type = object({
    instance_name      = string
    instance_count     = number
    availability_zones = list(string)
    flavor_name        = string
    image_id           = string
    tags               = map(string)
    metadata           = map(string)
  })

  default = {
    instance_name      = "firewall"
    instance_count     = 2
    availability_zones = ["eu-west-0a", "eu-west-0b"]
    flavor_name        = "t2.small"
    image_id           = "caad1499-9388-4222-b604-be2f57a85458"
    tags = {
      Environment = "landingzone"
    }
    metadata = {
      Terraform   = "true"
      Environment = "landingzone"
    }
  }
}

# DMZ Network variables
variable "network_vpc_dmz" {
  type = object({
    vpc_name    = string
    vpc_cidr    = string
    vpc_subnets = list(object({
      subnet_cidr       = string
      subnet_gateway_ip = string
      subnet_name       = string
    }))
  })

  default = {
    vpc_name    = "vpc-dmz"
    vpc_cidr    = "192.169.0.0/16"
    vpc_subnets = [
      {
        subnet_cidr       = "192.169.1.0/24"
        subnet_gateway_ip = "192.169.1.1"
        subnet_name       = "subnet-dmz"
      }
    ]
  }
}

variable "peering_dmz" {
  type = object({
    same_tenant  = bool
    peer_name    = string
  })

  default = {
    same_tenant  = true
    peer_name    = "peering-transit-dmz"
  }
}



// ------------------------- Dev variables



// ------------------------- PreProd variables



// ------------------------- Prod variables



// ------------------------- Monitoring & Logging variables