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

  name         = var.sfs_shares[count.index]["name"]
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

