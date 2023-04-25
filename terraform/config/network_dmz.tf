# Provision DMZ Network VPC and Subnets
module "network_vpc_dmz" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/vpc"

  vpc_name = "vpc-dmz"
  vpc_cidr = "192.169.0.0/16"
  vpc_subnets = [{
    subnet_cidr       = "192.169.1.0/24"
    subnet_gateway_ip = "192.169.1.1"
    subnet_name       = "subnet-dmz"
    }
  ]
}



// CCE Cluster
module "dmz_cce_cluster" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/cce"

  cluster_name      = "cluster-dmz"
  cluster_desc      = " Cluster for testing purpose"
  //availability_zone = "eu-west-0a"

  vpc_id          = module.network_vpc_dmz.vpc_id
  network_id      = module.network_vpc_dmz.network_ids[0] 
  cluster_version = "v1.25"
  
  cluster_high_availability = true
  cluster_type = "VirtualMachine"
  cluster_size = "large"
  cluster_container_network_type = "overlay_l2"

  node_os  = "EulerOS 2.9" // Can be "CentOS"
  key_pair = module.keypair.name

  nodes_list = [
    {
      node_index         = "node0"
      node_name          = "cce-node1"
      node_flavor        = "s3.large.2"
      availability_zone  = "eu-west-0a"
      root_volume_type   = "SATA"
      root_volume_size   = 40
      data_volume_type   = "SATA"
      data_volume_size   = 100
      node_labels        = {}
      vm_tags            = {}
      postinstall_script = null
      preinstall_script  = null
      taints             = []
    }
  ]

  depends_on = [
    module.keypair, module.network_vpc_dmz
  ]
}
