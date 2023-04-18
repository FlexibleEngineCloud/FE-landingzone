# Provision User Groups
module "network_vpc" {
  providers = {
    flexibleengine = flexibleengine.fe
  }

  source = "../modules/vpc"

  vpc_name = "vpc"
  vpc_cidr = "192.168.0.0/16"
  vpc_subnets = [ {
    subnet_cidr = "192.168.1.0/24"
    subnet_gateway_ip = "192.168.1.1"
    subnet_name = "subnet"
  } ]
}
