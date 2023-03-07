# ID String for resources, this string is generated randomly, to avoid name conflicts.
resource "random_string" "id" {
  length  = 4
  special = false
  upper   = false
}

# create CPE VPC.
resource "flexibleengine_vpc_v1" "vpc" {
  name = "vpc-cpe-${random_string.id.result}"
  cidr =  var.cidr_vpc

  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}
# create IN subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_in" {
  name       = "subnet-in-${random_string.id.result}"
  cidr       = var.cidr_subnet_in
  gateway_ip = var.gateway_in
  vpc_id     = flexibleengine_vpc_v1.vpc.id

  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}
# Create OUT subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_out" {
  name       = "subnet-out-${random_string.id.result}"
  cidr       = var.cidr_subnet_out
  gateway_ip = var.gateway_out
  vpc_id     = flexibleengine_vpc_v1.vpc.id

  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}
# Create Synchronization subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_sync" {
  name       = "subnet-sync-${random_string.id.result}"
  cidr       = var.cidr_subnet_sync
  gateway_ip = var.gateway_sync
  vpc_id     = flexibleengine_vpc_v1.vpc.id

  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}

# create DMZ VPC.
resource "flexibleengine_vpc_v1" "vpc_dmz" {
  name = "vpc-dmz-${random_string.id.result}"
  cidr =  var.cidr_dmz_vpc

  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}
# create DMZ subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_dmz" {
  name       = "subnet-dmz-${random_string.id.result}"
  cidr       = var.cidr_subnet_dmz
  gateway_ip = var.dmz_gateway
  vpc_id     = flexibleengine_vpc_v1.vpc_dmz.id

  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}

# create Prod VPC.
resource "flexibleengine_vpc_v1" "vpc_prod" {
  name = "vpc-prod-${random_string.id.result}"
  cidr =  var.cidr_prod_vpc

  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}
# create Application Prod subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_app" {
  name       = "subnet-app-${random_string.id.result}"
  cidr       = var.cidr_subnet_app
  gateway_ip = var.app_gateway
  vpc_id     = flexibleengine_vpc_v1.vpc_prod.id

  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}
# create Data Prod subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_data" {
  name       = "subnet-data-${random_string.id.result}"
  cidr       = var.cidr_subnet_data
  gateway_ip = var.data_gateway
  vpc_id     = flexibleengine_vpc_v1.vpc_prod.id

  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}

# create Dev VPC.
resource "flexibleengine_vpc_v1" "vpc_dev" {
  name = "vpc-dev-${random_string.id.result}"
  cidr =  var.cidr_dev_vpc

  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}
# create Dev subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_dev" {
  name       = "subnet-dev-${random_string.id.result}"
  cidr       = var.cidr_subnet_dev
  gateway_ip = var.dev_gateway
  vpc_id     = flexibleengine_vpc_v1.vpc_dev.id

  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}


# Create VPC peering between firewall VPC and DMZ vpc.
resource "flexibleengine_vpc_peering_connection_v2" "peering1" {
  name        = "peering1-${random_string.id.result}"
  vpc_id      = flexibleengine_vpc_v1.vpc.id
  peer_vpc_id = flexibleengine_vpc_v1.vpc_dmz.id
}
# Create VPC peering between firewall VPC and Prod vpc.
resource "flexibleengine_vpc_peering_connection_v2" "peering2" {
  name        = "peering2-${random_string.id.result}"
  vpc_id      = flexibleengine_vpc_v1.vpc.id
  peer_vpc_id = flexibleengine_vpc_v1.vpc_prod.id
}
# Create VPC peering between firewall VPC and Dev vpc.
resource "flexibleengine_vpc_peering_connection_v2" "peering3" {
  name        = "peering3-${random_string.id.result}"
  vpc_id      = flexibleengine_vpc_v1.vpc.id
  peer_vpc_id = flexibleengine_vpc_v1.vpc_dev.id
}

# Create EIP.
resource "flexibleengine_vpc_eip" "eip_1" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name = "eip-${random_string.id.result}"
    size = 5
    share_type = "PER"
    charge_mode = "traffic"
  }
  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}
# Enable AntiDDOS on EIP
resource "flexibleengine_antiddos_v1" "antiddos" {
  floating_ip_id         = flexibleengine_vpc_eip.eip_1.id
  enable_l7              = true
  traffic_pos_id         = 1
  http_request_pos_id    = 3
  cleaning_access_pos_id = 2
  app_type_id            = 0
}





/*
# Firewall VPC Route table
# Create default VPC route.
resource "flexibleengine_vpc_route" "vpc_route_1" {
  vpc_id         = flexibleengine_vpc_v1.vpc.id
  destination    = "0.0.0.0/0"
  type           = "ecs"
  nexthop        = flexibleengine_compute_instance_v2.firewall.id
}
# Create subnet remote VPC route.
resource "flexibleengine_vpc_route" "vpc_route_2" {
  vpc_id         = flexibleengine_vpc_v1.vpc.id
  destination    = "192.168.100.0/24"
  type           = "ecs"
  nexthop        = flexibleengine_compute_instance_v2.firewall.id
}
# Create private VPC route.
resource "flexibleengine_vpc_route" "vpc_route_3" {
  vpc_id         = flexibleengine_vpc_v1.vpc.id
  destination    = var.cidr_private_vpc
  type           = "peering"
  nexthop        = flexibleengine_vpc_peering_connection_v2.peering.id
}

# Private VPC Route table
# Create firewall VPC route.
resource "flexibleengine_vpc_route" "vpc_route_4" {
  vpc_id         = flexibleengine_vpc_v1.private-vpc.id
  destination    = "0.0.0.0/0"
  type           = "peering"
  nexthop        = flexibleengine_vpc_peering_connection_v2.peering.id
}
*/