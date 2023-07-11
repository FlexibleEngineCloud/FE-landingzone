# Random string
resource "random_string" "id" {
  length  = 4
  special = false
  upper   = false
}

# Provision Prod Network VPC and Subnets
module "vpc_prod" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/vpc"

  vpc_name = "vpc-prod"
  vpc_cidr = "192.168.3.0/24"
  vpc_subnets = [{
    subnet_cidr       = "192.168.3.0/27"
    subnet_gateway_ip = "192.168.3.1"
    subnet_name       = "subnet-prod"
    }
  ]
}

module "keypair_prod" {
  source = "../modules/keypair"
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }
  keyname = "TF-KeyPair-prod"
}

// Provision prod Security group
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

// Create VPC Peering from Prod to Transit VPC
module "peering_prod" {
  source = "../modules/vpcpeering"

  providers = {
    flexibleengine.requester = flexibleengine.prod_fe
    flexibleengine.accepter  = flexibleengine.network_fe
  }

  same_tenant = false
  tenant_acc_id = local.project_ids[var.network_tenant_name]

  peer_name = "peering-transit-prod"
  vpc_req_id = module.vpc_prod.vpc_id
  vpc_acc_id = module.network_vpc.vpc_id
}



// -------
// Examples Deployments modules for diverse FE Resources to implement to the landing zone.
// Resources: RDS, CCE, ELB shared, ELB Dedicated, OBS, S3, DNS, SFS,... 
// Modules To Uncomment and Use as needed.
// Please don't forget to uncomment outputs as well. from prod_outputs.tf
// Could be implemented as well in dev/preprod tenants, or transit tenant.
// -------


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

/*
# KMS key
module "kms_key" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/kms"

  key_alias       = "obs_key_${random_string.id.result}"
  pending_days    = "7"
  key_description = "obs key descritpion"
  realm           = "eu-west-0"
  is_enabled      = true
  rotation_enabled = true
  rotation_interval = 100
}
*/

/*
# Provision basic OBS Bucket
module "obs_prod_bucket" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/obs"

  bucket = "bucket-prod-${random_string.id.result}"
  acl    = "private"

  encryption    = false

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
  encryption    = false

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

  
  objects = [{
    key      = "object1"
    encryption = true
    acl = "private"
    storage_class = "STANDARD"

    // Either source or content must be provided
    //source    = "file.txt"
    content    = "file content"
    content_type    = "application/xml"
  },
  {
    key      = "object2"
    content    = "file content"
  }]
}
*/

/*
# Provision basic S3 Bucket
module "s3_prod_bucket" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/s3"

  bucket = "s3bucket-prod-${random_string.id.result}"
  acl    = "private"
}

# Provision advanced S3 Bucket
module "s3_prod_bucket_adv" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/s3"

  bucket        = "s3bucket-prod-advanced-${random_string.id.result}"
  acl           = "log-delivery-write"
  force_destroy = false

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
        "Resource": "arn:aws:s3:::s3bucket-prod-advanced-${random_string.id.result}/*", 
        "Condition": {
          "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
        } 
      } 
    ]
  }
  POLICY

  logging = {
    target_bucket = "s3bucket-prod-advanced-${random_string.id.result}"
    target_prefix = "prefix"
  }
  versioning = {
    enabled = true
    mfa_delete = true
  }

  website = {
    index_document = "*"
    error_document = "HTML"
    routing_rules = <<EOF
    [{
        "Condition": {
            "KeyPrefixEquals": "docs/"
        },
        "Redirect": {
            "ReplaceKeyPrefixWith": "documents/"
        }
    }]
    EOF
  }

  cors_rule = [{
    allowed_methods = ["PUT"]
    allowed_origins = ["*"]
    max_age_seconds = "100"
  }]

  lifecycle_rule = [{
    id    = "tmp"
    prefix  = "log/"
    enabled = true

    expiration = {
      days = 90
    }
  }]

  objects = [{
    key      = "object1"
    encryption = true
    acl = "private"

    // Either source or content must be provided
    //source    = "file.txt"
    content    = "file content"
  },
  {
    key      = "object2"
    content    = "file content"
  }]
}
*/

/*
# Provision DNS Zones
module "dns_zones" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/dns"

  zones = [{
    name        = "1.example.com."
    email       = "abdelmoumen.drici@orange.com"
    description = "my private zone"
    ttl         = 3000
    zone_type   = "private"
    //value_specs = {"ff","ee"}
    domain_name = "1.example.com"

    router_id     = module.vpc_prod.vpc_id
    router_region = "eu-west-0"

    dns_recordsets = [{
      name        = "rssfd"
      description = "An example record set"
      ttl         = 3000
      type        = "A"
      records     = ["10.0.0.1"]
    }]
  },
  {
    name        = "2.example2.com."
    zone_type   = "private"
    domain_name = "2.example2.com"

    router_id     = module.vpc_prod.vpc_id
    router_region = "eu-west-0"

    dns_recordsets = [{
      name        = "rssfd"
      type        = "A"
      records     = ["10.0.0.1"]
    }]
  }
  ]
}
*/

/*
# Provision SFS file systems
module "sfs_file_systems" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/sfs"

  sfs_shares = [{
    name      = "SFS1"
    size      = 1
    share_protocol    = "NFS"
    access_level    = "rw"
    vpc_id    = module.vpc_prod.vpc_id
    description = "sfs desc"

    kms_id    = "a4063d8c-df50-44ab-9f92-d1644632b298"
    kms_domain_id    = "5d32eb30f7074258a43bb55f29a5e337"
    kms_key_alias = "obs/default"

    access_to = join("#", [module.vpc_prod.vpc_id, "192.168.3.0/24", "0", "no_all_squash,no_root_squash"])
    access_level = "rw"
    access_type = "cert"
  },
  {
    name      = "SFS1"
    size = 2  

    //access_to = module.vpc_prod.vpc_id
    //access_level = "rw"
    //access_type = "cert"
  }]
  /*
  sfs_turbos = [{
    name      = "SFSTurbo1"
    size      = 500
    availability_zone = "eu-west-0a"
    security_group_id = module.sg_prod.id
    vpc_id    = module.vpc_prod.vpc_id
    subnet_id = module.vpc_prod.network_ids[0]

    share_protocol    = "NFS"
    kms_id    = "fedf145f-4c5e-4f9e-a4ee-1fee93b6d097"
    share_type = "STANDARD"
  }]
}
*/


/*
// if you haven't setted yet CCE on this tenant, you should have an agency for CCE service.
// this agency could be created as well, in console automatically the first time you use CCE. if you have already setted up CCE, consider commenting this module deployment.
module "cce_agency" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/iam/agency"

  name                   = "cce_admin_trust"
  delegated_service_name = "op_svc_cce"
  tenant_name            = var.prod_tenant_name
  roles                  = ["Tenant Administrator"]
  domain_roles           = ["OBS OperateAccess"]
  duration               = "FOREVER"
}

// CCE Cluster
module "cce_cluster" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/cce"

  cluster_name      = "cluster-prod"
  cluster_desc      = " Cluster for testing purpose"
  //availability_zone = "eu-west-0a"

  vpc_id          = module.vpc_prod.vpc_id
  network_id      = module.vpc_prod.network_ids[0] 
  cluster_version = "v1.25"
  
  cluster_high_availability = true
  cluster_type = "VirtualMachine"
  cluster_size = "large"
  cluster_container_network_type = "overlay_l2"

  node_os  = "EulerOS 2.9" // Can be "CentOS"
  key_pair = module.keypair_prod.name

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
    module.keypair_prod, module.vpc_prod, module.cce_agency
  ]
}
*/


/*
// Shared ELB
module "shared-elb" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/shared-elb"

  loadbalancer_name = "elb"
  subnet_id = module.vpc_prod.subnet_ids[0]
  vip_address = "192.169.1.149"
  security_group_ids = [module.sg_prod.id]

  tags =  {
    Environment = "landing-zoneee"
  }

  cert = true
  // making cert=true must either create a new certificate by putting certificate and private key.
  // Or if you have already a certificate put its certificate ID in certID variable.

  domain = "my-domain-name.com"
  cert_name = "my-cert-name"
  private_key = <<EOT
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAj8jVnej6gpeTmCCjAHXmsfBGQwej8RQ5Tl+762iQkE/0q9W0
W9laOl2seelFarXDxPf2/3FfROfwXErB4e8/XpSZRARVbtIhpQJ9Um5gnYP3TnnQ
bkeahQn84bGZiQ141Qot7gUy+fH9aHLzDCOk3dS+fA41ljht8k0r9/gwEOXlvpBv
NQTBt6yP8mb+0wBv2q77NOwWJ4GuknwGUv7VHvc4ZVG/V1poNB9Muxqa+E7kCHJ+
ChhDiX1jEtaMaaY+vIZyXrMKLyFsP75Ol4EnxA1Wb45u/fnJy8fxP3unIikgRc20
X8YZkAyvdKc3L2s7wKIv0T3nOfcL64eTFGXfBwIDAQABAoIBAEQzKSvY/bXiyrW+
SUKnKdEd3F3f6mGny5TCsQJ0mxlwa2f0GjP00SjdFLnQrUXzyFONoEFCl8M51pcY
OIV/s0mb52TNP26syhuYJjRquXYNSckV24jrer3+4k11LZPF6Zn3VZjQK4FFyIJ5
/5Gy+Hjl96IlJULHKlNjSmc4eCgTBVI8GXAou/xkqdL5IBnhdLfnf+DVWVaTPHmQ
XW2ner7YATrmd38VCuRYfhoxe5sKqy4NAhafjBuxi7I59QJEw0uc0sS9d8NmvGyZ
yPz2rEELXMn8/FlV6yawwJKzhQ7ysenO1kkVmRDZ18naQg9j19LklRjTwKyRHMiq
nctozOUCgYEAzvumNVQhxoMkyvY8ac0HgoN+A775J/lAIYvGpZSKy4+8+p4pHWsG
TAt/lp8JObtAnZ0WI3MkeKQ/QxdiicMH9muh3MYoH/1FA/qVF/+wPfN8gHD7ba8A
IzpUOMgPv6YbSX+e1kFXycH7tpISW+kTz3gugHd2VIFDnlf6nFmX520CgYEAsdXG
SRyal2IqUjdPFa8lh2mthzKjubnrM+vd4BQr8zTBiQEqurDJYbDQFQZPNEs7DIGv
bDZUdyb/Hwyltn8oB9JlneeiDELpij4JIsXJ4OkW9U1ml9xEVDSdn71/3EfZG/Fe
AH1gkd+bvJnH1HidcCwaO4/6SERlENcD9Onhk8MCgYEAy3B+0gXKWNKHtFHH2Xnj
Or3Bey8Wt9p91TsMWa0hqqix52bTJI4QF2hp1IKmT68j+IbwvpEqtMVDRM9UU/F0
/xiVdGj0AVUvo5SFPJxc/tc2dQwXpJwQN4/aPiEtkYJTaa9dUFvTTIQ0wyLZlqsF
hLMsiaphjPesnZL9yPUqoBUCgYBY6dhk758/dz5PswWggtyRsr2nLiN8Fb/KSvC5
O3yp8cOd+25gv0lAxcWT7X6mV8LjQufxg8yBcob2AD3OXA8osgJKi+iSltXrX47z
ys5f3Eq1RQi5ftDPBSuWFYobGfUsKmbkectRw+o6xuyJh/C3h+VpyFfL0B5z5/07
c8BsPwKBgAlNSkINF/q1Kk7+NVKAmOFtb8yCfVqekDehpowSw17WFsyziST8J5vn
mndA9D2tyO6XhuHAfh6fZrcp0Xpz/34Eh5/I+dtHRDcEx5ggo6GSFlL3k4jQNxvW
ShPz+DL6zEPDIyZDRma4nCEkOrI+5f6hOj08Uw5DLy00l/NuCuu1
-----END RSA PRIVATE KEY-----
EOT

  certificate = <<EOT
-----BEGIN CERTIFICATE-----
MIIDlTCCAn2gAwIBAgIERui7ZjANBgkqhkiG9w0BAQsFADBbMScwJQYDVQQDDB5SZWdlcnkgU2Vs
Zi1TaWduZWQgQ2VydGlmaWNhdGUxIzAhBgNVBAoMGlJlZ2VyeSwgaHR0cHM6Ly9yZWdlcnkuY29t
MQswCQYDVQQGEwJVQTAgFw0yMzA0MjcwMDAwMDBaGA8yMTIzMDQyNzIxMTU1N1owVzEjMCEGA1UE
AwwadGVzdC5mbGUteGlibGUtZW5nLWluZS5jb20xIzAhBgNVBAoMGlJlZ2VyeSwgaHR0cHM6Ly9y
ZWdlcnkuY29tMQswCQYDVQQGEwJVQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAI/I
1Z3o+oKXk5ggowB15rHwRkMHo/EUOU5fu+tokJBP9KvVtFvZWjpdrHnpRWq1w8T39v9xX0Tn8FxK
weHvP16UmUQEVW7SIaUCfVJuYJ2D90550G5HmoUJ/OGxmYkNeNUKLe4FMvnx/Why8wwjpN3UvnwO
NZY4bfJNK/f4MBDl5b6QbzUEwbesj/Jm/tMAb9qu+zTsFieBrpJ8BlL+1R73OGVRv1daaDQfTLsa
mvhO5AhyfgoYQ4l9YxLWjGmmPryGcl6zCi8hbD++TpeBJ8QNVm+Obv35ycvH8T97pyIpIEXNtF/G
GZAMr3SnNy9rO8CiL9E95zn3C+uHkxRl3wcCAwEAAaNjMGEwDwYDVR0TAQH/BAUwAwEB/zAOBgNV
HQ8BAf8EBAMCAYYwHQYDVR0OBBYEFJ7/3T+1Jk675IvAgb9HJ+D0cOToMB8GA1UdIwQYMBaAFJ7/
3T+1Jk675IvAgb9HJ+D0cOToMA0GCSqGSIb3DQEBCwUAA4IBAQBhIGyZwwr2wCVCKCiyONLeoUJh
x5TyQ1xdGwzxflB0Ue8u06LkYouR5Jo1KBkGj7MSCWabC0l7GZ3XcV5eMQ5JJSzM770evmNQTES3
I2WzxqnvDU0Ag5NNgXILjpHnBHP+s4ctdBWmOVeLFMygcOnnRhheGFKjKXhGwgOX/1Yv1qnzehJG
ZLOkHBLfNvHUN2QmL3J1Ma9dUPtgHgs91qWE7kSqt2zTEeNvuc9tvwludJzCan02BNMVRQhMevSJ
DC6FvpVEs8+tRudRfBXDJlaxw7MfMywsbDuTupthWOXJRseXRqTw7P3kxL+qSAurMQnqMJEbZXXS
RUrGxwdkw13Q
-----END CERTIFICATE-----
EOT

  //Uncomment if you have already certificate existing. put its certificate ID.
  //certId = "a67adc649b8a44d6ae7b5fb0041ed7d8" 
  //if you have already put certificate and privateID to create a new certificate, this variabla will be not necessary.

  listeners = [
    {
      name     = "testlistener"
      port     = 8080
      protocol = "TERMINATED_HTTPS"
      hasCert  = true  // must be true for HTTPS listener
      description = "test desc"
      
      http2_enable = true
      transparent_client_ip_enable = true
      idle_timeout = 40
      request_timeout = 50
      response_timeout = 60
      tls_ciphers_policy = "tls-1-1"
      
      tags = {
        Environment = "landing-zoneee"
      }
    },
    {
      name     = "httpslistener"
      port     = 80
      protocol = "HTTP"
      hasCert  = false
      description = "fsdffdsfd"
    }
  ]

  pools = [{
    name           = "pool_test"
    protocol       = "HTTP"
    lb_method      = "ROUND_ROBIN"
    listener_index = 0
    },
    {
      name           = "pool_test2"
      protocol       = "HTTP"
      lb_method      = "ROUND_ROBIN"
      listener_index = 1
    }
  ]

  backends = [
    {
      name          = "backend1"
      port          = 5044
      address_index = 0
      pool_index    = 0
      subnet_id     = module.vpc_prod.subnet_ids[0]
      weight = 4
      admin_state_up = true
    },
    {
      name          = "backend2"
      port          = 5044
      address_index = 1
      pool_index    = 0
      subnet_id     = module.vpc_prod.subnet_ids[0]
    }
  ]

  backends_addresses = ["192.169.1.102", "192.169.1.247"]

  monitors = [
    {
      name           = "monitor1"
      pool_index     = 0
      protocol       = "HTTP"
      delay          = 20
      timeout        = 10
      max_retries    = 3
      url_path       = "/check"
      http_method    = "GET"
      expected_codes = "400-404"
    },
    {
      name           = "monitor2"
      pool_index     = 1
      protocol       = "HTTP"
      delay          = 20
      timeout        = 10
      max_retries    = 3
      url_path       = "/check"
      http_method    = "GET"
      expected_codes = "200"
    }
  ]  

  l7policies = [
       {
      name                    = "redirect_to_https"
      action                  = "REDIRECT_TO_LISTENER"
      description             = "l7 policy to redirect http to https"
      position                = 1
      listener_index          = 1
      redirect_pool_index     = null
      redirect_listener_index = 0
    }
  ]

  //l7policies_rules = [
  //  {
  //    type           = "PATH"
  //    compare_type   = "EQUAL_TO"
  //    value          = "/api"
  //    l7policy_index = 0
  //    description = "rulee l7 "
  //  }
  //]
  
}


// Dedicated ELB
module "dedicated-elb" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/dedicated-elb"

  loadbalancer_name  = "elb"
  vpc_id             = module.vpc_prod.vpc_id
  subnet_id          = module.vpc_prod.subnet_ids[0]
  security_group_ids = [module.sg_prod.id]
  cross_vpc_backend  = true
  availability_zones = [
    "eu-west-0a",
    "eu-west-0b"
  ]

  tags = {
    Environment = "landing-zoneee"
  }

  cert = true
  // making cert=true must either create a new certificate by putting certificate and private key.
  // Or if you have already a certificate put its certificate ID in certID variable.

  domain      = "my-domain-name.com"
  cert_name   = "my-cert-name"
  private_key = <<EOT
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAj8jVnej6gpeTmCCjAHXmsfBGQwej8RQ5Tl+762iQkE/0q9W0
W9laOl2seelFarXDxPf2/3FfROfwXErB4e8/XpSZRARVbtIhpQJ9Um5gnYP3TnnQ
bkeahQn84bGZiQ141Qot7gUy+fH9aHLzDCOk3dS+fA41ljht8k0r9/gwEOXlvpBv
NQTBt6yP8mb+0wBv2q77NOwWJ4GuknwGUv7VHvc4ZVG/V1poNB9Muxqa+E7kCHJ+
ChhDiX1jEtaMaaY+vIZyXrMKLyFsP75Ol4EnxA1Wb45u/fnJy8fxP3unIikgRc20
X8YZkAyvdKc3L2s7wKIv0T3nOfcL64eTFGXfBwIDAQABAoIBAEQzKSvY/bXiyrW+
SUKnKdEd3F3f6mGny5TCsQJ0mxlwa2f0GjP00SjdFLnQrUXzyFONoEFCl8M51pcY
OIV/s0mb52TNP26syhuYJjRquXYNSckV24jrer3+4k11LZPF6Zn3VZjQK4FFyIJ5
/5Gy+Hjl96IlJULHKlNjSmc4eCgTBVI8GXAou/xkqdL5IBnhdLfnf+DVWVaTPHmQ
XW2ner7YATrmd38VCuRYfhoxe5sKqy4NAhafjBuxi7I59QJEw0uc0sS9d8NmvGyZ
yPz2rEELXMn8/FlV6yawwJKzhQ7ysenO1kkVmRDZ18naQg9j19LklRjTwKyRHMiq
nctozOUCgYEAzvumNVQhxoMkyvY8ac0HgoN+A775J/lAIYvGpZSKy4+8+p4pHWsG
TAt/lp8JObtAnZ0WI3MkeKQ/QxdiicMH9muh3MYoH/1FA/qVF/+wPfN8gHD7ba8A
IzpUOMgPv6YbSX+e1kFXycH7tpISW+kTz3gugHd2VIFDnlf6nFmX520CgYEAsdXG
SRyal2IqUjdPFa8lh2mthzKjubnrM+vd4BQr8zTBiQEqurDJYbDQFQZPNEs7DIGv
bDZUdyb/Hwyltn8oB9JlneeiDELpij4JIsXJ4OkW9U1ml9xEVDSdn71/3EfZG/Fe
AH1gkd+bvJnH1HidcCwaO4/6SERlENcD9Onhk8MCgYEAy3B+0gXKWNKHtFHH2Xnj
Or3Bey8Wt9p91TsMWa0hqqix52bTJI4QF2hp1IKmT68j+IbwvpEqtMVDRM9UU/F0
/xiVdGj0AVUvo5SFPJxc/tc2dQwXpJwQN4/aPiEtkYJTaa9dUFvTTIQ0wyLZlqsF
hLMsiaphjPesnZL9yPUqoBUCgYBY6dhk758/dz5PswWggtyRsr2nLiN8Fb/KSvC5
O3yp8cOd+25gv0lAxcWT7X6mV8LjQufxg8yBcob2AD3OXA8osgJKi+iSltXrX47z
ys5f3Eq1RQi5ftDPBSuWFYobGfUsKmbkectRw+o6xuyJh/C3h+VpyFfL0B5z5/07
c8BsPwKBgAlNSkINF/q1Kk7+NVKAmOFtb8yCfVqekDehpowSw17WFsyziST8J5vn
mndA9D2tyO6XhuHAfh6fZrcp0Xpz/34Eh5/I+dtHRDcEx5ggo6GSFlL3k4jQNxvW
ShPz+DL6zEPDIyZDRma4nCEkOrI+5f6hOj08Uw5DLy00l/NuCuu1
-----END RSA PRIVATE KEY-----
EOT

  certificate = <<EOT
-----BEGIN CERTIFICATE-----
MIIDlTCCAn2gAwIBAgIERui7ZjANBgkqhkiG9w0BAQsFADBbMScwJQYDVQQDDB5SZWdlcnkgU2Vs
Zi1TaWduZWQgQ2VydGlmaWNhdGUxIzAhBgNVBAoMGlJlZ2VyeSwgaHR0cHM6Ly9yZWdlcnkuY29t
MQswCQYDVQQGEwJVQTAgFw0yMzA0MjcwMDAwMDBaGA8yMTIzMDQyNzIxMTU1N1owVzEjMCEGA1UE
AwwadGVzdC5mbGUteGlibGUtZW5nLWluZS5jb20xIzAhBgNVBAoMGlJlZ2VyeSwgaHR0cHM6Ly9y
ZWdlcnkuY29tMQswCQYDVQQGEwJVQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAI/I
1Z3o+oKXk5ggowB15rHwRkMHo/EUOU5fu+tokJBP9KvVtFvZWjpdrHnpRWq1w8T39v9xX0Tn8FxK
weHvP16UmUQEVW7SIaUCfVJuYJ2D90550G5HmoUJ/OGxmYkNeNUKLe4FMvnx/Why8wwjpN3UvnwO
NZY4bfJNK/f4MBDl5b6QbzUEwbesj/Jm/tMAb9qu+zTsFieBrpJ8BlL+1R73OGVRv1daaDQfTLsa
mvhO5AhyfgoYQ4l9YxLWjGmmPryGcl6zCi8hbD++TpeBJ8QNVm+Obv35ycvH8T97pyIpIEXNtF/G
GZAMr3SnNy9rO8CiL9E95zn3C+uHkxRl3wcCAwEAAaNjMGEwDwYDVR0TAQH/BAUwAwEB/zAOBgNV
HQ8BAf8EBAMCAYYwHQYDVR0OBBYEFJ7/3T+1Jk675IvAgb9HJ+D0cOToMB8GA1UdIwQYMBaAFJ7/
3T+1Jk675IvAgb9HJ+D0cOToMA0GCSqGSIb3DQEBCwUAA4IBAQBhIGyZwwr2wCVCKCiyONLeoUJh
x5TyQ1xdGwzxflB0Ue8u06LkYouR5Jo1KBkGj7MSCWabC0l7GZ3XcV5eMQ5JJSzM770evmNQTES3
I2WzxqnvDU0Ag5NNgXILjpHnBHP+s4ctdBWmOVeLFMygcOnnRhheGFKjKXhGwgOX/1Yv1qnzehJG
ZLOkHBLfNvHUN2QmL3J1Ma9dUPtgHgs91qWE7kSqt2zTEeNvuc9tvwludJzCan02BNMVRQhMevSJ
DC6FvpVEs8+tRudRfBXDJlaxw7MfMywsbDuTupthWOXJRseXRqTw7P3kxL+qSAurMQnqMJEbZXXS
RUrGxwdkw13Q
-----END CERTIFICATE-----
EOT

  //Uncomment if you have already certificate existing. put its certificate ID.
  //certId = "a67adc649b8a44d6ae7b5fb0041ed7d8" 
  //if you have already put certificate and privateID to create a new certificate, this variabla will be not necessary.

  ipgroups = [
    {
      name           = "ipgroup1"
      description    = "descriisfd "
      listener_index = 0

      ips  = [
        {
          ip          = "192.168.33.2"
          description = "description 1 here"
        },
        {
          ip          = "192.168.33.1"
          description = "description 2 here"
        }
      ]
    },
    {
      name           = "ipgroup2"
      listener_index = 1

      ips = [
        {
          ip          = "192.168.33.3"
          description = "description 3 here"
        }
      ]

    }
  ]

  listeners = [
    {
      name        = "testlistener"
      port        = 8080
      protocol    = "HTTPS"
      hasCert     = true // must be true for HTTPS listener
      description = "test desc"

      http2_enable       = true
      idle_timeout       = 40
      request_timeout    = 50
      response_timeout   = 60
      tls_ciphers_policy = "tls-1-1"

      forward_eip = true

      // either "white" or "black" for whitelisting and blacklisting ip address group
      // Setting access_policy must be followed with ip_group config
      access_policy = "black"

      advanced_forwarding_enabled = true

      tags = {
        Environment = "landing-zoneee"
      }
    },
    {
      name        = "httpslistener"
      port        = 443
      protocol    = "HTTPS"
      hasCert     = true // must be true for HTTPS listener
      description = "test desc"

      // either "white" or "black" for whitelisting and blacklisting ip address group
      // Setting access_policy must be followed with ip_group config
      access_policy = "white"
    },
    {
      name        = "httplistener"
      port        = 80
      protocol    = "HTTP"
      hasCert     = false
      description = "fsdffdsfd"

      tags = {
        Environment = "landing-zoneee"
      }
    }
  ]

  pools = [{
    name           = "pool_test"
    protocol       = "HTTPS"
    lb_method      = "ROUND_ROBIN"
    listener_index = 0
    },
    {
      name           = "pool_test2"
      protocol       = "HTTPS"
      lb_method      = "ROUND_ROBIN"
      listener_index = 1
    },
    {
      name           = "pool_test3"
      protocol       = "HTTP"
      lb_method      = "ROUND_ROBIN"
      listener_index = 2
    }
  ]

  backends = [
    {
      name          = "backend1"
      port          = 5044
      address_index = 0
      pool_index    = 0
      subnet_id     = module.vpc_prod.subnet_ids[0]
      weight        = 4
    },
    {
      name          = "backend2"
      port          = 5044
      address_index = 1
      pool_index    = 1
      subnet_id     = module.vpc_prod.subnet_ids[0]
    }
  ]

  backends_addresses = ["192.169.1.102", "192.169.1.247"]

  monitors = [
    {
      pool_index  = 0
      protocol    = "HTTPS"
      interval    = 20
      timeout     = 10
      max_retries = 3

      url_path = "/check"
    },
    {
      pool_index  = 1
      protocol    = "HTTP"
      interval    = 20
      timeout     = 10
      max_retries = 3
      port        = 5044

      url_path = "/check"
    }
  ]
}
*/