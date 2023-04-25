variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of the cluster"
  type        = string
}

variable "cluster_desc" {
  description = "Description of the cluster"
  type        = string
}

variable "cluster_type" {
  type        = string
  description = "Cluster type: VirtualMachine or BareMetal (default: VirtualMachine)"
  default     = "VirtualMachine"

  validation {
    condition     = contains(["VirtualMachine", "BareMetal"], var.cluster_type == null ? "VirtualMachine" : var.cluster_type)
    error_message = "Allowed values for cluster_type are \"VirtualMachine\" and \"BareMetal\"."
  }
}

variable "cluster_high_availability" {
  type        = bool
  description = "Create the cluster in highly available mode (default: false)"
  default     = false
}

variable "cluster_size" {
  type        = string
  description = "Size of the cluster: small, medium, large (default: small)"
  default     = "small"
  validation {
    condition     = contains(["small", "medium", "large"], lower(var.cluster_size))
    error_message = "Allowed values for cluster_size are \"small\", \"medium\" and \"large\"."
  }
}

variable "availability_zone" {
  description = "Availability Zone used to deploy"
  default     = "eu-west-0a"
  type        = string
}

variable "cluster_container_network_type" {
  type        = string
  description = "Container network type: vpc-router or overlay_l2 for VirtualMachine Clusters; underlay_ipvlan for BareMetal Clusters"
  default     = "overlay_l2"
}

/*
  #o	cce.s1.large : no HA > 1000nodes
  #o	cce.s1.medium : no HA 50 à 200 nodes
  #o	cce.s1.small : no HA up to 50 nodes
  #o	cce.s2.large : HA > 1000nodes
  #o	cce.s2.medium : HA 50 à 200 nodes
  #o	cce.s2.small : HA up to 50 nodes
*/

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "network_id" {
  description = "ID of the Network"
  type        = string
}

variable "node_os" {
  description = "Operating System of the CCE Worker Node"
  type        = string
}

variable "key_pair" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "extend_param" {
  description = "Extended Parameters"
  type        = map(string)
  default     = {}
}

variable "nodes_list" {
  description = "Nodes list of the CCE2 Cluster"
  default     = []
  type = list(object({
    node_index        = string
    node_name         = string
    node_flavor       = string
    availability_zone = string
    root_volume_size  = number
    root_volume_type  = string
    data_volume_size  = number
    data_volume_type  = string
    node_labels       = map(string)
    vm_tags           = map(string)
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
    postinstall_script = string
    preinstall_script  = string
  }))
}

variable "node_pool_list" {
  description = "Nodes pool list of the CCE2 Cluster"
  default     = []
  type = list(object({
    node_pool_index          = string
    node_pool_name           = string
    node_flavor              = string
    availability_zone        = string
    initial_node_count       = number
    scall_enable             = bool
    min_node_count           = number
    max_node_count           = number
    scale_down_cooldown_time = number
    priority                 = number
    root_volume_size         = number
    root_volume_type         = string
    type                     = string
    data_volume_size         = number
    data_volume_type         = string
    node_labels              = map(string)
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
    postinstall_script = string
    preinstall_script  = string
  }))
}