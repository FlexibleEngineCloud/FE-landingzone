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
variable "kms_key_dev" {
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
    key_alias          = "kms_key_dev"
    pending_days       = "7"
    key_description    = "KMS key for dev project"
    realm              = "eu-west-0"
    is_enabled         = true
    rotation_enabled   = true
    rotation_interval  = 100
  }
}

variable "keypair_dev" {
  type = string

  default = "TF-KeyPair-dev"
}

variable "vpc_dev" {
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
    vpc_name    = "vpc-dev"
    vpc_cidr    = "192.168.4.0/24"
    vpc_subnets = [
      {
        subnet_cidr       = "192.168.4.0/27"
        subnet_gateway_ip = "192.168.4.1"
        subnet_name       = "subnet-dev"
      }
    ]
  }
}

variable "peering_dev" {
  type = object({
    same_tenant  = bool
    peer_name    = string
  })

  default = {
    same_tenant  = false
    peer_name    = "peering-transit-dev"
  }
}



// ------------------------- PreProd variables
variable "kms_key_preprod" {
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
    key_alias          = "kms_key_preprod"
    pending_days       = "7"
    key_description    = "KMS key for preprod project"
    realm              = "eu-west-0"
    is_enabled         = true
    rotation_enabled   = true
    rotation_interval  = 100
  }
}

variable "keypair_preprod" {
  type = string

  default = "TF-KeyPair-preprod"
}

variable "vpc_preprod" {
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
    vpc_name    = "vpc-preprod"
    vpc_cidr    = "192.168.5.0/24"
    vpc_subnets = [
      {
        subnet_cidr       = "192.168.5.0/27"
        subnet_gateway_ip = "192.168.5.1"
        subnet_name       = "subnet-preprod"
      }
    ]
  }
}

variable "peering_preprod" {
  type = object({
    same_tenant  = bool
    peer_name    = string
  })

  default = {
    same_tenant  = false
    peer_name    = "peering-transit-preprod"
  }
}



// ------------------------- Prod variables
variable "kms_key_prod" {
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
    key_alias          = "kms_key_prod"
    pending_days       = "7"
    key_description    = "KMS key for prod project"
    realm              = "eu-west-0"
    is_enabled         = true
    rotation_enabled   = true
    rotation_interval  = 100
  }
}

variable "keypair_prod" {
  type = string

  default = "TF-KeyPair-prod"
}

variable "vpc_prod" {
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
    vpc_name    = "vpc-prod"
    vpc_cidr    = "192.168.3.0/24"
    vpc_subnets = [
      {
        subnet_cidr       = "192.168.3.0/27"
        subnet_gateway_ip = "192.168.3.1"
        subnet_name       = "subnet-prod"
      }
    ]
  }
}

variable "sg_prod" {
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
    name                        = "sg_prod"
    description                 = "Security group for prod instances"
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

variable "peering_prod" {
  type = object({
    same_tenant  = bool
    peer_name    = string
  })

  default = {
    same_tenant  = false
    peer_name    = "peering-transit-prod"
  }
}



// ------------------------- Monitoring & Logging variables
variable "obs_cts_bucket" {
  type = object({
    bucket    = string
    acl       = string
    encryption    = bool
    versioning = bool
  })

  default = {
    bucket    = "bucket-cts-landingzone"
    acl       = "private"
    encryption    = false
    versioning = true
  }
}

variable "cts_obs_role" {
  type = object({
    name        = string
    description = string
    type        = string
  })

  default = {
    name        = "delegate-cts-obs"
    description = "Delegate access on CTS OBS bucket"
    type        = "AX"
  }
}



variable "lts_group_names" {
  type = object({
    prod = string
    dev = string
    preprod = string
    network = string
    shared = string
  })

  default = {
    prod   = "Prod_Group"
    dev   = "Dev_Group"
    preprod   = "PreProd_Group"
    network   = "Network_Group"
    shared   = "ShardServices_Group"
  }
}

variable "lts_topic_names" {
  type = object({
    prod = string
    dev = string
    preprod = string
    dmz = string
    bastion = string
    transit = string
    shared = string
  })

  default = {
    prod   = "Prod_Hosts_Topic"
    dev   = "Dev_Hosts_Topic"
    preprod   = "PreProd_Hosts_Topic"
    dmz   = "DMZ_Hosts_Topic"
    bastion   = "Bastion_Hosts_Topic"
    transit = "Transit_Hosts_Topic"
    shared = "SharedServices_Hosts_Topic"
  }
}


variable "ces_smn" {
  type = object({
    topic_name         = string
    topic_display_name = string
    subscriptions      = list(object({
      endpoint = string
      protocol = string
      remark   = string
    }))
  })

  default = {
    topic_name         = "ces-topic"
    topic_display_name = "Cloud Eye SMN Topic"
    subscriptions      = [{
      endpoint  = "abdelmoumen.drici@orange.com"
      protocol  = "email"
      remark    = "O&M"
    }]
  }
}


/*
variable "ces_rules" {
  type = list(object({
    alarm_name      = string
    metric          = list(object({
      namespace   = string
      metric_name = string
      dimensions  = list(object({
        name  = string
        value = string
      }))
    }))
    condition       = list(object({
      period              = number
      filter              = string
      comparison_operator = string
      value               = number
      count               = number
    }))
    alarm_actions   = list(object({
      type               = string
      notification_list  = list(string)
    }))
  }))

  default = [{
    alarm_name = "firewall1-cpu"

    metric = [{
      namespace   = "SYS.ECS"
      metric_name = "cpu_util"
      dimensions = [{
        name  = "instance_id"
        value = module.ecs_cluster.id[0]
      }]
    }]

    condition = [{
      period              = 1
      filter              = "average"
      comparison_operator = ">="
      value               = 80
      count               = 1
    }]
    
    alarm_actions = [{
      type = "notification"
      notification_list = [
        module.ces_smn.topic_urns[0]
      ]
    }]
  },
  {
    alarm_name = "firewall2-cpu"

    metric = [{
      namespace   = "SYS.ECS"
      metric_name = "cpu_util"
      dimensions = [{
        name  = "instance_id"
        value = module.ecs_cluster.id[1]
      }]
    }]

    condition = [{
      period              = 1
      filter              = "average"
      comparison_operator = ">="
      value               = 80
      count               = 1
    }]
    
    alarm_actions = [{
      type = "notification"
      notification_list = [
        module.ces_smn.topic_urns[0]
      ]
    }]
  },
  {
    alarm_name = "firewall1-mem"

    metric = [{
      namespace   = "SYS.ECS"
      metric_name = "mem_util"
      dimensions = [{
        name  = "instance_id"
        value = module.ecs_cluster.id[0]
      }]
    }]

    condition = [{
      period              = 1
      filter              = "average"
      comparison_operator = ">="
      value               = 80
      count               = 1
    }]
    
    alarm_actions = [{
      type = "notification"
      notification_list = [
        module.ces_smn.topic_urns[0]
      ]
    }]
  },
  {
    alarm_name = "firewall2-mem"

    metric = [{
      namespace   = "SYS.ECS"
      metric_name = "mem_util"
      dimensions = [{
        name  = "instance_id"
        value = module.ecs_cluster.id[1]
      }]
    }]

    condition = [{
      period              = 1
      filter              = "average"
      comparison_operator = ">="
      value               = 80
      count               = 1
    }]
    
    alarm_actions = [{
      type = "notification"
      notification_list = [
        module.ces_smn.topic_urns[0]
      ]
    }]
  }]
}
*/