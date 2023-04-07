# ID String for resources, this string is generated randomly, to avoid name conflicts.
resource "random_string" "id" {
  length  = 4
  special = false
  upper   = false
}

# create remote VPC.
resource "flexibleengine_vpc_v1" "vpc" {
  name = "vpc-remote-${random_string.id.result}"
  cidr = var.cidr_remote_vpc

  tags = {
    scenario = var.tag
  }
}
# create remote subnet.
resource "flexibleengine_vpc_subnet_v1" "subnet_remote" {
  name       = "subnet-remote-${random_string.id.result}"
  cidr       = var.cidr_subnet_remote
  gateway_ip = var.remote_gateway
  vpc_id     = flexibleengine_vpc_v1.vpc.id

  tags = {
    scenario = var.tag
  }
}