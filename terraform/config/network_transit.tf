# Provision KMS key for network tenant
module "network_kms_key" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/kms"

  key_alias         = "${var.network_kms_key.key_alias}_${random_string.id.result}"
  pending_days      = var.network_kms_key.pending_days
  key_description   = var.network_kms_key.key_description
  realm             = var.network_kms_key.realm
  is_enabled        = var.network_kms_key.is_enabled
  rotation_enabled  = var.network_kms_key.rotation_enabled
  rotation_interval = var.network_kms_key.rotation_interval
}

# Provision RSA KeyPair for network tenant
module "network_keypair" {
  source = "../modules/keypair"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }
  keyname = var.network_keypair
}


# Provision Network VPC and Subnets
module "network_vpc" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/vpc"

  vpc_name    = var.network_vpc.vpc_name
  vpc_cidr    = var.network_vpc.vpc_cidr
  vpc_subnets = var.network_vpc.vpc_subnets
}


# Provision Virtual inbound IP
module "network_vip_in" {
  source = "../modules/vip"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  vip_name   = var.network_vips.inbound_vip_name
  ip_address = var.network_vips.inbound
  subnet_id  = module.network_vpc.network_ids[0]
  port_ids   = [for instance_network in module.ecs_cluster.network : instance_network.0.port]

  depends_on = [
    module.network_vpc, module.ecs_cluster
  ]
}

# Provision Virtual outbound IP
module "network_vip_out" {
  source = "../modules/vip"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  vip_name   = var.network_vips.outbound_vip_name
  ip_address = var.network_vips.outbound
  subnet_id  = module.network_vpc.network_ids[1]
  port_ids   = [for instance_network in module.ecs_cluster.network : instance_network.1.port]

  depends_on = [
    module.network_vpc, module.ecs_cluster
  ]
}


# Provision Public IP
module "firewall_eip" {
  source = "../modules/eip"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  eip_count     = 1
  eip_name      = var.firewall_eip.eip_name
  eip_bandwidth = var.firewall_eip.eip_bandwidth
  protect_eip   = var.firewall_eip.protect_eip

  depends_on = [
    module.network_vip_in, module.network_vip_out
  ]
}

# Assign AntiDDOS
module "antiddos" {
  source = "../modules/antiddos"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  eips = [
    for id in module.firewall_eip.ids : {
      floating_ip_id         = id
      enable_l7              = var.antiddos.enable_l7
      traffic_pos_id         = var.antiddos.traffic_pos_id
      http_request_pos_id    = var.antiddos.http_request_pos_id
      cleaning_access_pos_id = var.antiddos.cleaning_access_pos_id
      app_type_id            = var.antiddos.app_type_id
    }
  ]

  depends_on = [
    module.firewall_eip
  ]
}


module "sg_firewall" {
  source = "../modules/secgroup"
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  name                        = var.sg_firewall.name
  description                 = var.sg_firewall.description
  delete_default_egress_rules = var.sg_firewall.delete_default_egress_rules

  ingress_with_source_cidr = var.sg_firewall.ingress_with_source_cidr
}



# Provision Firewall instances
module "ecs_cluster" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/ecs"

  instance_name      = var.ecs_cluster.instance_name
  instance_count     = var.ecs_cluster.instance_count
  availability_zones = var.ecs_cluster.availability_zones

  flavor_name = var.ecs_cluster.flavor_name
  image_id    = var.ecs_cluster.image_id

  key_name        = module.network_keypair.id
  security_groups = [module.sg_firewall.name]
  network_uuids   = module.network_vpc.network_ids

  tags = var.ecs_cluster.tags

  metadata = var.ecs_cluster.metadata

  depends_on = [
    module.network_keypair, module.sg_firewall, module.network_vpc
  ]
}
