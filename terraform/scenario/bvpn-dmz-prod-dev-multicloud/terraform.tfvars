domain_name = "OCB000XXXX"
tenant_name = "eu-west-0"
region = "eu-west-0"

tag = "bvpn-dmz-prod-dev-multicloud"

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