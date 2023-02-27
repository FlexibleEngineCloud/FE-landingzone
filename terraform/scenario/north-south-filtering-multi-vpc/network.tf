# ID String for resources, this string is generated randomly, to avoid name conflicts.
resource "random_string" "id" {
  length  = 4
  special = false
  upper   = false
}

# create VPC.
resource "flexibleengine_vpc_v1" "vpc" {
  name = "vpc-${random_string.id.result}"
  cidr =  var.cidr_vpc

  tags = {
    scenario  = "multi-vpc-north-south-filtering"
  }
}
# create IN subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet-in" {
  name       = "subnet-in-${random_string.id.result}"
  cidr       = var.cidr_subnet_in
  gateway_ip = var.gateway_in
  vpc_id     = flexibleengine_vpc_v1.vpc.id

  tags = {
    scenario  = "multi-vpc-north-south-filtering"
  }
}
# Create OUT subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet-out" {
  name       = "subnet-out-${random_string.id.result}"
  cidr       = var.cidr_subnet_out
  gateway_ip = var.gateway_out
  vpc_id     = flexibleengine_vpc_v1.vpc.id

  tags = {
    scenario  = "multi-vpc-north-south-filtering"
  }
}

# create Private VPC.
resource "flexibleengine_vpc_v1" "private-vpc" {
  name = "private-vpc-${random_string.id.result}"
  cidr =  var.cidr_private_vpc

  tags = {
    scenario  = "multi-vpc-north-south-filtering"
  }
}
# create private subnet.
resource "flexibleengine_vpc_subnet_v1" "private-subnet" {
  name       = "private-subnet-${random_string.id.result}"
  cidr       = var.cidr_private_subnet
  gateway_ip = var.private_gateway
  vpc_id     = flexibleengine_vpc_v1.private-vpc.id

  tags = {
    scenario  = "multi-vpc-north-south-filtering"
  }
}

# Create VPC peering between private vpc and firewall vpc.
resource "flexibleengine_vpc_peering_connection_v2" "peering" {
  name        = "peering-${random_string.id.result}"
  vpc_id      = flexibleengine_vpc_v1.vpc.id
  peer_vpc_id = flexibleengine_vpc_v1.private-vpc.id
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
    scenario  = "multi-vpc-north-south-filtering"
  }
}

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