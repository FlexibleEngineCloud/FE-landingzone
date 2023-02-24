domain_name = "OCB000XXXX"
tenant_name = "XXXXXXXXXXXXXX"
region = "eu-west-0"
availability_zone_names = [
  "eu-west-0a",
  "eu-west-0b",
  "eu-west-0c"
]

cidr_vpc = "192.168.0.0/16"
cidr_subnet_in = "192.168.1.0/24"
cidr_subnet_out = "192.168.2.0/24"
gateway_in = "192.168.1.1"
gateway_out = "192.168.2.1"

cidr_private_vpc = "192.169.0.0/16"
cidr_private_subnet = "192.169.1.0/24"
private_gateway = "192.169.1.1"