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
    scenario  = "mono-north-south-filtering"
  }
}
# create IN subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet-in" {
  name       = "subnet-in-${random_string.id.result}"
  cidr       = var.cidr_subnet_in
  gateway_ip = var.gateway_in
  vpc_id     = flexibleengine_vpc_v1.vpc.id

  tags = {
    scenario  = "mono-north-south-filtering"
  }
}

# Create OUT subnet
resource "flexibleengine_vpc_subnet_v1" "subnet-out" {
  name       = "subnet-out-${random_string.id.result}"
  cidr       = var.cidr_subnet_out
  gateway_ip = var.gateway_out
  vpc_id     = flexibleengine_vpc_v1.vpc.id

  tags = {
    scenario  = "mono-north-south-filtering"
  }
}

# EIP Creation
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
    scenario  = "mono-north-south-filtering"
  }
}

# default route
resource "flexibleengine_vpc_route" "vpc_route" {
  vpc_id         = flexibleengine_vpc_v1.vpc.id
  destination    = "0.0.0.0/0"
  type           = "ecs"
  nexthop        = flexibleengine_compute_instance_v2.firewall.network.0.fixed_ip_v4
}
# default route
resource "flexibleengine_vpc_route" "vpc_route" {
  vpc_id         = flexibleengine_vpc_v1.vpc.id
  destination    = "0.0.0.0/0"
  type           = "ecs"
  nexthop        = var.nexthop
}