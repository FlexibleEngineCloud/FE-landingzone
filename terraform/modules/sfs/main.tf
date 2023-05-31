# SFS Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_sfs_file_system_v2" "sfs" {
  count = length(var.sfs_shares)

  name         = var.sfs_shares[count.index]["name"] == null ? null : var.sfs_shares[count.index]["share_protocol"]
  size         = var.sfs_shares[count.index]["size"]
  share_proto  = var.sfs_shares[count.index]["share_protocol"] == null ? null : var.sfs_shares[count.index]["share_protocol"]
  access_level = var.sfs_shares[count.index]["access_level"] == null ? null : var.sfs_shares[count.index]["access_level"]
  access_to    = var.sfs_shares[count.index]["vpc_id"] == null ? null : var.sfs_shares[count.index]["vpc_id"]
  description  = var.sfs_shares[count.index]["description"] == null ? null : var.sfs_shares[count.index]["description"]

  metadata = {
    "#sfs_crypt_key_id"    = var.sfs_shares[count.index]["kms_id"] == null ? null : var.sfs_shares[count.index]["kms_id"]
    "#sfs_crypt_domain_id" = var.sfs_shares[count.index]["kms_domain_id"] == null ? null : var.sfs_shares[count.index]["kms_domain_id"]
    "#sfs_crypt_alias"     = var.sfs_shares[count.index]["kms_key_alias"] == null ? null : var.sfs_shares[count.index]["kms_key_alias"]
  }
}

resource "flexibleengine_sfs_access_rule_v2" "rules" {
  count = length(var.sfs_shares)

  sfs_id        = flexibleengine_sfs_file_system_v2.sfs[count.index].id
  access_to     = var.sfs_shares[count.index].rules[0].access_to
  access_type   = var.sfs_shares[count.index].rules[0].access_type == null ? null : var.sfs_shares[count.index].rules[0].access_type
  access_level  = var.sfs_shares[count.index].rules[0].access_level == null ? null : var.sfs_shares[count.index].rules[0].access_level
}


resource "flexibleengine_sfs_turbo" "sfs_turbos" {
  count = length(var.sfs_turbos)

  name         = var.sfs_turbos[count.index]["name"] 
  size         = var.sfs_turbos[count.index]["size"]
  availability_zone = var.sfs_turbos[count.index]["availability_zone"]
  security_group_id = var.sfs_turbos[count.index]["security_group_id"]
  vpc_id    = var.sfs_turbos[count.index]["vpc_id"]
  subnet_id    = var.sfs_turbos[count.index]["subnet_id"]

  share_type = var.sfs_turbos[count.index]["share_type"] == null ? null : var.sfs_turbos[count.index]["share_type"]
  share_proto  = var.sfs_turbos[count.index]["share_protocol"] == null ? null : var.sfs_turbos[count.index]["share_protocol"]
  crypt_key_id  = var.sfs_turbos[count.index]["kms_id"] == null ? null : var.sfs_turbos[count.index]["kms_id"]
}

