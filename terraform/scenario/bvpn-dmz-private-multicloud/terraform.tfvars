domain_name = "XXXXXXXX"
tenant_name = "XXXXXXXX"
region = "eu-west-0"

tag = "bvpn-dmz-private-multicloud"

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

cidr_private_vpc = "192.168.2.0/24"
cidr_subnet_private = "192.168.2.0/27"
private_gateway = "192.168.2.1"