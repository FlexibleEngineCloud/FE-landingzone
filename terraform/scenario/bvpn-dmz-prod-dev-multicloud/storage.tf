# Create SFS Turbo
resource "flexibleengine_sfs_turbo" "sfs-turbo" {
  name        = "sfs-turbo-${random_string.id.result}"
  size        = 500
  share_proto = "NFS"
  vpc_id      = flexibleengine_vpc_v1.vpc_prod.id
  subnet_id   = flexibleengine_vpc_subnet_v1.subnet_data.id
  security_group_id = flexibleengine_networking_secgroup_v2.secgroup_1.id
  availability_zone = "eu-west-0a"
  crypt_key_id = flexibleengine_kms_key_v1.kmskey.id
}

# Create RDS instance
resource "flexibleengine_rds_instance_v3" "rds-instance" {
  name              = "rds-instance-${random_string.id.result}"
  flavor            = "rds.pg.s3.large.4.ha"
  ha_replication_mode = "async"
  availability_zone = [ "eu-west-0b","eu-west-0c" ]
  security_group_id = flexibleengine_networking_secgroup_v2.secgroup_1.id
  vpc_id            = flexibleengine_vpc_v1.vpc_prod.id
  subnet_id         = flexibleengine_vpc_subnet_v1.subnet_data.id

  db {
    type     = "PostgreSQL"
    version  = "11"
    password = var.db_pass
    port     = "8635"
  }
  volume {
    type = "COMMON"
    size = 100
  }
}
