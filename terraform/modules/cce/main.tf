# AntiDDOS Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}


// Create Agency for CCE provisioning
resource "flexibleengine_identity_agency_v3" "agency" {
  name                   = "cce_admin_trust"
  description            = "Create by Terraform"
  delegated_service_name = "op_svc_cce"

  project_role {
    project = "eu-west-0_Netowrk2"
    roles = [
      "Tenant Administrator",
    ]
  }
  domain_roles = [
    "OBS OperateAccess",
  ]
}

# Provision CCE Cluster
resource "flexibleengine_cce_cluster_v3" "cce_cluster" {
  name                   = var.cluster_name
  cluster_type           = var.cluster_type
  cluster_version        = var.cluster_version
  flavor_id              = "cce.${var.cluster_type == "BareMetal" ? "t" : "s"}${var.cluster_high_availability ? 2 : 1}.${lower(var.cluster_size)}"
  vpc_id                 = var.vpc_id
  subnet_id              = var.network_id
  container_network_type = var.cluster_container_network_type
  description            = var.cluster_desc
  extend_param           = var.extend_param
  
  timeouts {
    create = "60m"
    delete = "60m"
  }

  depends_on = [
    flexibleengine_identity_agency_v3.agency
  ]
}

# Provision CCE Cluster nodes
resource "flexibleengine_cce_node_v3" "cce_cluster_node" {
  count = length(var.nodes_list)

  cluster_id = flexibleengine_cce_cluster_v3.cce_cluster.id
  name       = var.nodes_list[count.index]["node_name"]
  flavor_id  = var.nodes_list[count.index]["node_flavor"]
  os         = var.node_os

  availability_zone = var.nodes_list[count.index]["availability_zone"]
  key_pair          = var.key_pair

  postinstall = var.nodes_list[count.index]["postinstall_script"]
  preinstall  = var.nodes_list[count.index]["preinstall_script"]

  labels = var.nodes_list[count.index]["node_labels"]
  tags   = var.nodes_list[count.index]["vm_tags"]

  root_volume {
    size       = var.nodes_list[count.index]["root_volume_size"]
    volumetype = var.nodes_list[count.index]["root_volume_type"]
    #kms_id     = var.node_storage_encryption_enabled ? (var.node_storage_encryption_kms_key_name == null ? flexibleengine_kms_key_v1.node_storage_encryption_key[0].id : data.flexibleengine_kms_key_v1.node_storage_encryption_existing_key[0].id) : null
  }

  data_volumes {
    size       = var.nodes_list[count.index]["data_volume_size"]
    volumetype = var.nodes_list[count.index]["data_volume_type"]
    #kms_id     = var.node_storage_encryption_enabled ? (var.node_storage_encryption_kms_key_name == null ? flexibleengine_kms_key_v1.node_storage_encryption_key[0].id : data.flexibleengine_kms_key_v1.node_storage_encryption_existing_key[0].id) : null
  }

  dynamic "taints" {
    for_each = var.nodes_list[count.index]["taints"]
    content {
      key    = taints.value.key
      value  = taints.value.value
      effect = taints.value.effect
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [annotations, labels]
  }
}

# Provision CCE node pools
resource "flexibleengine_cce_node_pool_v3" "cce_node_pool" {
  count = length(var.node_pool_list)

  cluster_id = flexibleengine_cce_cluster_v3.cce_cluster.id
  name       = var.node_pool_list[count.index]["node_pool_name"]
  os         = var.node_os

  flavor_id         = var.node_pool_list[count.index]["node_flavor"]
  availability_zone = var.node_pool_list[count.index]["availability_zone"]
  key_pair          = var.key_pair

  initial_node_count       = var.node_pool_list[count.index]["initial_node_count"]
  scall_enable             = var.node_pool_list[count.index]["scall_enable"]
  min_node_count           = var.node_pool_list[count.index]["min_node_count"]
  max_node_count           = var.node_pool_list[count.index]["max_node_count"]
  scale_down_cooldown_time = var.node_pool_list[count.index]["scale_down_cooldown_time"]
  priority                 = var.node_pool_list[count.index]["priority"]

  type = var.node_pool_list[count.index]["type"]

  postinstall = var.node_pool_list[count.index]["postinstall_script"]
  preinstall  = var.node_pool_list[count.index]["preinstall_script"]

  labels = var.node_pool_list[count.index]["node_labels"]

  root_volume {
    size       = var.node_pool_list[count.index]["root_volume_size"]
    volumetype = var.node_pool_list[count.index]["root_volume_type"]
  }

  data_volumes {
    size       = var.node_pool_list[count.index]["data_volume_size"]
    volumetype = var.node_pool_list[count.index]["data_volume_type"]
  }

  dynamic "taints" {
    for_each = var.node_pool_list[count.index]["taints"]
    content {
      key    = taints.value.key
      value  = taints.value.value
      effect = taints.value.effect
    }
  }
}