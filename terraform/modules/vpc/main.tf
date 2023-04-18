# VPC Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_vpc_v1" "vpc" {
  name = var.vpc_name
  cidr = var.vpc_cidr
}

resource "flexibleengine_vpc_subnet_v1" "vpc_subnets" {
  # Create subnets
  for_each = local.vpc_subnets_map

  name          = each.value.subnet_name
  cidr          = each.key
  gateway_ip    = each.value.subnet_gateway_ip
  primary_dns   = var.primary_dns
  secondary_dns = var.secondary_dns
  vpc_id        = flexibleengine_vpc_v1.vpc.id
}

locals {
  vpc_subnets_keys   = [for subnet in var.vpc_subnets : subnet.subnet_cidr]
  vpc_subnets_values = [for subnet in var.vpc_subnets : subnet]
  vpc_subnets_map    = zipmap(local.vpc_subnets_keys, local.vpc_subnets_values)
}