# ID String for resources, this string is generated randomly, to avoid name conflicts.
resource "random_string" "id" {
  length  = 4
  special = false
  upper   = false
}

# create CPE VPC.
resource "flexibleengine_vpc_v1" "vpc" {
  name = "vpc-cpe-${random_string.id.result}"
  cidr = var.cidr_vpc

  tags = {
    scenario = var.tag
  }
}
# create IN subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_in" {
  name       = "subnet-in-${random_string.id.result}"
  cidr       = var.cidr_subnet_in
  gateway_ip = var.gateway_in
  vpc_id     = flexibleengine_vpc_v1.vpc.id

  tags = {
    scenario = var.tag
  }
}
# Create OUT subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_out" {
  name       = "subnet-out-${random_string.id.result}"
  cidr       = var.cidr_subnet_out
  gateway_ip = var.gateway_out
  vpc_id     = flexibleengine_vpc_v1.vpc.id

  tags = {
    scenario = var.tag
  }
}
# Create Synchronization subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_sync" {
  name       = "subnet-sync-${random_string.id.result}"
  cidr       = var.cidr_subnet_sync
  gateway_ip = var.gateway_sync
  vpc_id     = flexibleengine_vpc_v1.vpc.id

  tags = {
    scenario = var.tag
  }
}

# create DMZ VPC.
resource "flexibleengine_vpc_v1" "vpc_dmz" {
  name = "vpc-dmz-${random_string.id.result}"
  cidr = var.cidr_dmz_vpc

  tags = {
    scenario = var.tag
  }
}
# create DMZ subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_dmz" {
  name       = "subnet-dmz-${random_string.id.result}"
  cidr       = var.cidr_subnet_dmz
  gateway_ip = var.dmz_gateway
  vpc_id     = flexibleengine_vpc_v1.vpc_dmz.id

  tags = {
    scenario = var.tag
  }
}

# create Private VPC.
resource "flexibleengine_vpc_v1" "vpc_private" {
  name = "vpc-private-${random_string.id.result}"
  cidr = var.cidr_private_vpc

  tags = {
    scenario = var.tag
  }
}

# create Private subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_private" {
  name       = "subnet-private-${random_string.id.result}"
  cidr       = var.cidr_subnet_private
  gateway_ip = var.private_gateway
  vpc_id     = flexibleengine_vpc_v1.vpc_private.id

  tags = {
    scenario = var.tag
  }
}

# Create VPC peering between firewall VPC and DMZ vpc.
resource "flexibleengine_vpc_peering_connection_v2" "peering1" {
  name        = "peering1-${random_string.id.result}"
  vpc_id      = flexibleengine_vpc_v1.vpc.id
  peer_vpc_id = flexibleengine_vpc_v1.vpc_dmz.id
}

# Create VPC peering between firewall VPC and Private vpc.
resource "flexibleengine_vpc_peering_connection_v2" "peering2" {
  name        = "peering2-${random_string.id.result}"
  vpc_id      = flexibleengine_vpc_v1.vpc.id
  peer_vpc_id = flexibleengine_vpc_v1.vpc_private.id
}

# Create EIP.
resource "flexibleengine_vpc_eip" "eip_1" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "eip-${random_string.id.result}"
    size        = 5
    share_type  = "PER"
    charge_mode = "traffic"
  }
  tags = {
    scenario = var.tag
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


# CPE VPC Route table
# Create default VPC route.
resource "flexibleengine_vpc_route" "vpc_route_1" {
  vpc_id      = flexibleengine_vpc_v1.vpc.id
  destination = "0.0.0.0/0"
  type        = "vip"
  nexthop     = flexibleengine_networking_vip_v2.vip_in.ip_address
}

# Create subnet IN custom route table.
resource "flexibleengine_vpc_route_table" "route_table" {
  name    = "custom-rtb-${random_string.id.result}"
  vpc_id  = flexibleengine_vpc_v1.vpc.id
  subnets = [flexibleengine_vpc_subnet_v1.subnet_in.id]

  route {
    destination = "192.168.1.0/24"
    type        = "peering"
    nexthop     = flexibleengine_vpc_peering_connection_v2.peering1.id
  }
  route {
    destination = "192.168.2.0/24"
    type        = "peering"
    nexthop     = flexibleengine_vpc_peering_connection_v2.peering2.id
  }
}

# DMZ VPC Route table
# Create default route.
resource "flexibleengine_vpc_route" "vpc_route_2" {
  vpc_id      = flexibleengine_vpc_v1.vpc_dmz.id
  destination = "0.0.0.0/0"
  type        = "peering"
  nexthop     = flexibleengine_vpc_peering_connection_v2.peering1.id
}


# Private VPC Route table
# Create default route.
resource "flexibleengine_vpc_route" "vpc_route_3" {
  vpc_id      = flexibleengine_vpc_v1.vpc_private.id
  destination = "0.0.0.0/0"
  type        = "peering"
  nexthop     = flexibleengine_vpc_peering_connection_v2.peering2.id
}