
# Provision Prod Network VPC and Subnets
module "vpc_prod" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/vpc"

  vpc_name = "vpc-appdev"
  vpc_cidr = "192.168.3.0/24"
  vpc_subnets = [{
    subnet_cidr       = "192.168.3.0/27"
    subnet_gateway_ip = "192.168.3.1"
    subnet_name       = "subnet-prod"
    }
  ]
}

module "sg_prod" {
  source = "../modules/secgroup"
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  name                        = "sg_prod"
  description                 = "Security group for prod instances"
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
module "rds_prod" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/rds"

  vpc_id    = module.vpc_prod.vpc_id
  subnet_id = module.vpc_prod.network_ids[0]

  db_type             = "MySQL"
  db_version          = "5.7"
  db_flavor           = "rds.mysql.s3.medium.4"
  secgroup_id         = module.sg_prod.id
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

  depends_on = [ module.vpc_prod, module.sg_prod ]
}
*/

/*
# Provision RDS advanced instance
module "rds_prod_ha" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/rds"

  vpc_id    = module.vpc_prod.vpc_id
  subnet_id = module.vpc_prod.network_ids[0]

  db_type             = "MySQL"
  db_version          = "5.7"
  db_flavor           = "rds.mysql.s3.medium.4.ha"
  secgroup_id         = module.sg_prod.id
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

  depends_on = [ module.vpc_prod, module.sg_prod ]
}
*/

# Random string
resource "random_string" "id" {
  length  = 4
  special = false
  upper   = false
}

# Provision basic OBS Bucket
module "obs_prod_bucket" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/obs"

  bucket = "bucket-prod-${random_string.id.result}"
  acl    = "private"

  versioning = true
}

# Provision basic OBS Bucket
module "obs_prod_bucket2" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/obs"

  bucket = "bucket-prod2-${random_string.id.result}"
  acl    = "private"

  versioning = true
}

# Provision advanced OBS Bucket
module "obs_prod_bucket_adv" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/obs"

  bucket        = "bucket-prod-advanced-${random_string.id.result}"
  storage_class = "STANDARD"
  versioning    = true
  acl           = "log-delivery-write"
  multi_az      = true
  force_destroy = false
  encryption    = true

  attach_policy = true
  policy        = <<POLICY
  {
    "Id": "MYBUCKETPOLICY",
    "Statement": [
      {
        "Sid": "IPAllow",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "*",
        "Resource": "arn:aws:s3:::bucket-prod-advanced-${random_string.id.result}/*", 
        "Condition": {
          "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
        } 
      } 
    ]
  }
  POLICY

  logging = {
    target_bucket = "bucket-prod-advanced-${random_string.id.result}"
    target_prefix = "prefix"
  }
  website = {
    index_document = "*"
    error_document = "HTML"
  }

  cors_rule = [{
    allowed_methods = ["PUT"]
    allowed_origins = ["*"]
    max_age_seconds = "100"
  }]

  lifecycle_rule = [{
    name    = "rule-bucket-prod-advanced-${random_string.id.result}"
    prefix  = "file"
    enabled = true

    expiration = {
      days = 25
    }
    transition = {
      days          = 10
      storage_class = "GLACIER"
    }
    noncurrent_version_expiration = {
      days = 60
    }
    noncurrent_version_transition = {
      days          = 40
      storage_class = "STANDARD_IA"
    }

  }]

  notifications = [{
    name      = "notifiactin_name1"
    topic_urn = "urn:smn:eu-west-0:ce6b52a3710d4ea28eb45f637930db7a:test_topic"
    events    = ["ObjectCreated:*"]
    prefix    = "file"
    suffix    = ".jpg"
  }]

  // replica must not be on the current bucket, the bucket must be created before.
  create_replica = true
  replica = [{
    bucket      = "bucket-prod-${random_string.id.result}"
    destination_bucket = "bucket-prod2-${random_string.id.result}"
    agency    = "obs-agency"
    rules = [ {
      enabled       = true
      prefix        = "file"
      storage_class = "WARM"
    } ]
  }]

}
