# Create ECS instance1 for prod app subnet.
resource "flexibleengine_compute_instance_v2" "instance1" {
  name            = "instance1-${random_string.id.result}"
  image_id        = "c2280a5f-159f-4489-a107-7cf0c7efdb21"
  flavor_id       = "s6.small.1"
  key_pair        = flexibleengine_compute_keypair_v2.keypair.name
  security_groups = ["default",flexibleengine_networking_secgroup_v2.secgroup_1.name]
  availability_zone = "eu-west-0b"

  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet_app.id
  }
  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}

# Create ECS instance2 for prod app subnet.
resource "flexibleengine_compute_instance_v2" "instance2" {
  name            = "instance2-${random_string.id.result}"
  image_id        = "c2280a5f-159f-4489-a107-7cf0c7efdb21"
  flavor_id       = "s6.small.1"
  key_pair        = flexibleengine_compute_keypair_v2.keypair.name
  security_groups = ["default",flexibleengine_networking_secgroup_v2.secgroup_1.name]
  availability_zone = "eu-west-0c"

  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet_app.id
  }
  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}

/*
# Create BMS server
resource "flexibleengine_compute_bms_server_v2" "bms-server" {
  name              = "bms-${random_string.id.result}"
  image_id          = "82f5cac6-d667-41bb-91ea-39ca7704187d"
  flavor_id         = "physical.o3.small"
  key_pair          = flexibleengine_compute_keypair_v2.keypair.name
  security_groups   = ["default",flexibleengine_networking_secgroup_v2.secgroup_1.name]
  availability_zone = "eu-west-0a"

  metadata = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
  network {
    uuid = flexibleengine_vpc_subnet_v1.subnet_app.id
  }
}
*/

# Create MRS Cluster.
resource "flexibleengine_mrs_cluster_v2" "mrs-cluster" {
  availability_zone  = "eu-west-0b"
  name               = "mrs-cluster-${random_string.id.result}"
  type               = "ANALYSIS"
  version            = "MRS 3.1.0-LTS.1"
  manager_admin_pwd  = var.mrs_pass
  node_key_pair      = flexibleengine_compute_keypair_v2.keypair.name

  vpc_id            = flexibleengine_vpc_v1.vpc_prod.id
  subnet_id         = flexibleengine_vpc_subnet_v1.subnet_data.id

  safe_mode = false

  component_list     = ["Hadoop", "Hive", "Hue", "Loader", "Oozie", "ZooKeeper", "Ranger", "Tez"]
  master_nodes {
    flavor            = "c6.4xlarge.4.linux.mrs"
    node_number       = 2
    root_volume_type  = "SAS"
    root_volume_size  = 480
    data_volume_type  = "SAS"
    data_volume_size  = 600
    data_volume_count = 1
  }
  analysis_core_nodes {
    flavor            = "c6.4xlarge.4.linux.mrs"
    node_number       = 3
    root_volume_type  = "SAS"
    root_volume_size  = 480
    data_volume_type  = "SAS"
    data_volume_size  = 600
    data_volume_count = 1
  }
  tags = {
    scenario  = "bvpn-transit-dmz-private-multicloud"
  }
}