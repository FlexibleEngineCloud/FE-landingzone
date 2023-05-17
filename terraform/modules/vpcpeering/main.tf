# VPC Peering Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

provider "flexibleengine" {
  alias = "requester"
}

provider "flexibleengine" {
  alias = "accepter"
}

# Get IDs of VPC
data "flexibleengine_vpc_v1" "vpc_req" {
  # Get the ID of VPC requester
  count    = var.vpc_req_name != null ? 1 : 0
  provider = flexibleengine.requester
  name     = var.vpc_req_name
}

data "flexibleengine_vpc_v1" "vpc_acc" {
  # Get the ID of VPC peer
  count    = var.vpc_acc_name != null ? 1 : 0
  provider = flexibleengine.accepter
  name     = var.vpc_acc_name
}

# Requester's side of the connection.
resource "flexibleengine_vpc_peering_connection_v2" "peering" {
  provider       = flexibleengine.requester
  name           = var.peer_name
  vpc_id         = var.vpc_req_id != null ? var.vpc_req_id : data.flexibleengine_vpc_v1.vpc_req[0].id
  peer_vpc_id    = var.vpc_acc_id != null ? var.vpc_acc_id : data.flexibleengine_vpc_v1.vpc_acc[0].id
  peer_tenant_id = var.tenant_acc_id == null ? null : var.tenant_acc_id
}

# Accepter's side of the connection. In other Tenant
resource "flexibleengine_vpc_peering_connection_accepter_v2" "peer" {
  count                     = var.same_tenant ? 0 : 1
  provider                  = flexibleengine.accepter
  vpc_peering_connection_id = flexibleengine_vpc_peering_connection_v2.peering.id
  accept                    = true
}