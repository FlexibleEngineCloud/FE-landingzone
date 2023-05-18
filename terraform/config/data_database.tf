
# Provision AppDev Network VPC and Subnets
module "vpc_appdev" {
  providers = {
    flexibleengine = flexibleengine.appdev_fe
  }

  source = "../modules/vpc"

  vpc_name = "vpc-appdev"
  vpc_cidr = "192.174.0.0/16"
  vpc_subnets = [{
    subnet_cidr       = "192.174.1.0/24"
    subnet_gateway_ip = "192.174.1.1"
    subnet_name       = "subnet-appdev"
    }
  ]
}

module "sg_appdev" {
  source = "../modules/secgroup"
  providers = {
    flexibleengine = flexibleengine.appdev_fe
  }

  name                        = "sg_appdev"
  description                 = "Security group for appdev instances"
  delete_default_egress_rules = false

  ingress_with_source_cidr = [
    {
      from_port   = 10
      to_port     = 1000
      protocol    = "tcp"
      ethertype   = "IPv4"
      source_cidr = "0.0.0.0/0"
    }
  ]
}

/*
# Provision RDS instance
module "rds_appdev" {
  providers = {
    flexibleengine = flexibleengine.appdev_fe
  }

  source = "../modules/rds"

  vpc_id    = module.vpc_appdev.vpc_id
  subnet_id = module.vpc_appdev.network_ids[0]

  db_type             = "MySQL"
  db_version          = "5.7"
  db_flavor           = "rds.mysql.s3.medium.4"
  secgroup_id         = module.sg_appdev.id
  db_tcp_port         = "8635"
  db_backup_starttime = "08:00-09:00"
  db_backup_keepdays  = 4
  db_root_password    = "FooBarPasswd1234!"

  //HA disabled
  rds_ha_enable      = false
  rds_ha_replicamode = "async"
  rds_instance_az          = ["eu-west-0a"]

  rds_instance_name        = "rds_mysql_foo"
  rds_instance_volume_type = "COMMON"
  rds_instance_volume_size = 100

  rds_parametergroup_values = {
    time_zone              = "Europe/Paris"
    lower_case_table_names = "0"
  }
  
  rds_databases_list = []
  rds_privileges_list = []
  rds_accounts_list = []
  rds_read_replicat_list = []

  depends_on = [ module.vpc_appdev, module.sg_appdev ]
}
*/


# Provision RDS advanced instance
module "rds_appdev" {
  providers = {
    flexibleengine = flexibleengine.appdev_fe
  }

  source = "../modules/rds"

  vpc_id    = module.vpc_appdev.vpc_id
  subnet_id = module.vpc_appdev.network_ids[0]

  db_type             = "MySQL"
  db_version          = "5.7"
  db_flavor           = "rds.mysql.s3.medium.4.ha"
  secgroup_id         = module.sg_appdev.id
  db_tcp_port         = "8635"
  db_backup_starttime = "08:00-09:00"
  db_backup_keepdays  = 4
  db_root_password    = "FooBarPasswd1234!"

  //HA enabled
  // when enabling HA, consider updating flavor as well by adding "ha" to the flavor "rds.mysql.s3.medium.4.ha"
  // and adding AZ in rds_instance_az
  rds_ha_enable      = true
  rds_ha_replicamode = "async"
  rds_instance_az          = ["eu-west-0a","eu-west-0b"]

  //HA disabled
  //rds_ha_enable      = false
  //rds_ha_replicamode = "async"
  //rds_instance_az          = ["eu-west-0a"]

  rds_instance_name        = "rds_mysql_foo"
  rds_instance_volume_type = "COMMON"
  rds_instance_volume_size = 100

  rds_parametergroup_values = {
    time_zone              = "Europe/Paris"
    lower_case_table_names = "0"
  }
  
  rds_databases_list = [
    {
      name = "main_db"
      char_set = "utf8"
    }
  ]

  rds_privileges_list = [
    {
      db_name = "main_db"
      name = "account2"
      readonly = true
    }
  ]

  rds_accounts_list = [
    {
      name = "account1"
      password = "FooBarPasswd1234!"
    },
    {
      name = "account2"
      password = "FooBarPasswd1234!"
    }
  ]

  rds_read_replicat_list = [
   {
      name = "read1"
      flavor = "rds.mysql.s3.medium.4.rr"
      availability_zone = "eu-west-0a"

      volume_type = "ULTRAHIGH"
    }
  ]

  depends_on = [ module.vpc_appdev, module.sg_appdev ]
}