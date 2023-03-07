domain_name = "XXXXXXXXXX"
tenant_name = "XXXXXXXXXX"
region = "eu-west-0"
availability_zone_names = [
  "eu-west-0a",
  "eu-west-0b",
  "eu-west-0c"
]

cidr_vpc = "192.168.0.0/24"
cidr_subnet_in = "192.168.0.128/27"
cidr_subnet_out = "192.168.0.0/27"
cidr_subnet_sync = "192.168.0.64/27"
gateway_in = "192.168.0.129"
gateway_out = "192.168.0.1"
gateway_sync = "192.168.0.65"

cidr_dmz_vpc = "192.168.1.0/24"
cidr_subnet_dmz = "192.168.1.0/27"
dmz_gateway = "192.168.1.1"

cidr_prod_vpc = "192.168.2.0/24"
cidr_subnet_app = "192.168.2.0/27"
cidr_subnet_data = "192.168.2.128/27"
app_gateway = "192.168.2.1"
data_gateway = "192.168.2.129"

cidr_dev_vpc = "192.168.3.0/24"
cidr_subnet_dev = "192.168.3.0/27"
dev_gateway = "192.168.3.1"