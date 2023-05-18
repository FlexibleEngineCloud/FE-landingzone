# VPC Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_rds_parametergroup_v3" "parametergroup" {
  count       = length(var.rds_parametergroup_values) > 0 ? 1 : 0
  name        = "parametergroup-${var.rds_instance_name}"
  description = var.rds_description == "" ? "parametergroup-${var.rds_instance_name} rds description" : var.rds_description
  values      = var.rds_parametergroup_values 
  datastore {
    type    = lower(var.db_type)
    version = var.db_version
  }
}

resource "flexibleengine_rds_instance_v3" "instance" {
  name              = var.rds_instance_name
  security_group_id = var.secgroup_id
  subnet_id         = var.subnet_id
  vpc_id            = var.vpc_id
  availability_zone = var.rds_instance_az
  flavor              = var.db_flavor
  ha_replication_mode = var.rds_ha_enable ? var.rds_ha_replicamode : null

  fixed_ip = var.fixed_ip == null ? null : var.fixed_ip
  time_zone = var.time_zone == null ? null : var.time_zone
  ssl_enable = var.ssl_enable == null ? null : var.ssl_enable
  param_group_id = length(var.rds_parametergroup_values) > 0 ? flexibleengine_rds_parametergroup_v3.parametergroup.*.id[0] : null

  db {
    password = var.db_root_password
    type     = var.db_type
    version  = var.db_version
    port     = var.db_tcp_port
  }
  volume {
    type               = var.rds_instance_volume_type
    size               = var.rds_instance_volume_size
    disk_encryption_id = var.rds_instance_volume_encryption_id
  }
  backup_strategy {
    start_time = var.db_backup_starttime == null ? null : var.db_backup_starttime
    keep_days  = var.db_backup_keepdays == null ? null : var.db_backup_keepdays
  }

  tags = var.tags
}

resource "flexibleengine_rds_read_replica_v3" "read_instances" {
  count = length(var.rds_read_replicat_list) > 0 ? length(var.rds_read_replicat_list) : 0

  name              = var.rds_read_replicat_list[count.index]["name"] == null ? null : var.rds_read_replicat_list[count.index]["name"]
  flavor            = var.rds_read_replicat_list[count.index]["flavor"] == null ? null : var.rds_read_replicat_list[count.index]["flavor"]
  availability_zone = var.rds_read_replicat_list[count.index]["availability_zone"] == null ? null : var.rds_read_replicat_list[count.index]["availability_zone"]
  replica_of_id     = flexibleengine_rds_instance_v3.instance.id

  volume {
    type               = var.rds_read_replicat_list[count.index]["volume_type"] == null ? null : var.rds_read_replicat_list[count.index]["volume_type"]
    disk_encryption_id = var.rds_read_replicat_list[count.index]["disk_encryption_id"] == null ? null : var.rds_read_replicat_list[count.index]["disk_encryption_id"]
  }
}


resource "flexibleengine_rds_account" "accounts" {
  count = length(var.rds_accounts_list) > 0 ? length(var.rds_accounts_list) : 0

  instance_id = flexibleengine_rds_instance_v3.instance.id
  name        =  var.rds_accounts_list[count.index]["name"] == null ? null : var.rds_accounts_list[count.index]["name"]
  password    =  var.rds_accounts_list[count.index]["password"] == null ? null : var.rds_accounts_list[count.index]["password"]
}

resource "flexibleengine_rds_database" "databases" {
  count = length(var.rds_databases_list) > 0 ? length(var.rds_databases_list) : 0

  instance_id = flexibleengine_rds_instance_v3.instance.id
  name        =  var.rds_databases_list[count.index]["name"] == null ? null : var.rds_databases_list[count.index]["name"] 
  character_set    =  var.rds_databases_list[count.index]["char_set"] == null ? null : var.rds_databases_list[count.index]["char_set"]
}


resource "flexibleengine_rds_database_privilege" "privileges" {
  count = length(var.rds_privileges_list) > 0 ? length(var.rds_privileges_list) : 0

  instance_id = flexibleengine_rds_instance_v3.instance.id 
  db_name     = var.rds_databases_list[count.index]["db_name"] == null ? null : var.rds_databases_list[count.index]["db_name"]

  users {
    name     = var.rds_databases_list[count.index]["name"] == null ? null : var.rds_databases_list[count.index]["name"]
    readonly = var.rds_databases_list[count.index]["readonly"] == null ? null : var.rds_databases_list[count.index]["readonly"]
  }
}