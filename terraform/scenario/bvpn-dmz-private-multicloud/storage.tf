# Create RDS instance
resource "flexibleengine_rds_instance_v3" "rds-instance" {
  name              = "rds-instance-${random_string.id.result}"
  flavor            = "rds.pg.s3.large.4.ha"
  ha_replication_mode = "async"
  availability_zone = [ "eu-west-0b","eu-west-0c" ]
  security_group_id = flexibleengine_networking_secgroup_v2.secgroup_1.id
  vpc_id            = flexibleengine_vpc_v1.vpc_private.id
  subnet_id         = flexibleengine_vpc_subnet_v1.subnet_private.id

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
