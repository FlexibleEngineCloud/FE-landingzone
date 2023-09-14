# Provision TMS Tags
resource "flexibleengine_tms_tags" "tags" {
  provider = flexibleengine.home_fe
  
  dynamic "tags" {
    for_each = local.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# Provision CTS OBS Bucket for Network tenant
module "obs_cts_bucket_network" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/obs"

  bucket = "${var.obs_cts_bucket.bucket}-network-${random_string.id.result}"
  acl    = var.obs_cts_bucket.acl
  encryption    = var.obs_cts_bucket.encryption
  versioning = var.obs_cts_bucket.versioning
}


# Provision CTS OBS Bucket for Dev tenant
module "obs_cts_bucket_dev" {
  providers = {
    flexibleengine = flexibleengine.dev_fe
  }

  source = "../modules/obs"

  bucket = "${var.obs_cts_bucket.bucket}-dev-${random_string.id.result}"
  acl    = var.obs_cts_bucket.acl
  encryption    = var.obs_cts_bucket.encryption
  versioning = var.obs_cts_bucket.versioning
}

# Provision CTS OBS Bucket for PreProd tenant
module "obs_cts_bucket_preprod" {
  providers = {
    flexibleengine = flexibleengine.preprod_fe
  }

  source = "../modules/obs"

  bucket = "${var.obs_cts_bucket.bucket}-preprod-${random_string.id.result}"
  acl    = var.obs_cts_bucket.acl
  encryption    = var.obs_cts_bucket.encryption
  versioning = var.obs_cts_bucket.versioning
}

# Provision CTS OBS Bucket for Prod tenant
module "obs_cts_bucket_prod" {
  providers = {
    flexibleengine = flexibleengine.prod_fe
  }

  source = "../modules/obs"

  bucket = "${var.obs_cts_bucket.bucket}-prod-${random_string.id.result}"
  acl    = var.obs_cts_bucket.acl
  encryption    = var.obs_cts_bucket.encryption
  versioning = var.obs_cts_bucket.versioning
}

# Provision CTS OBS Bucket for Shared services
module "obs_cts_bucket_shared" {
  providers = {
    flexibleengine = flexibleengine.sharedservices_fe
  }

  source = "../modules/obs"

  bucket = "${var.obs_cts_bucket.bucket}-sharedservices-${random_string.id.result}"
  acl    = var.obs_cts_bucket.acl
  encryption    = var.obs_cts_bucket.encryption
  versioning = var.obs_cts_bucket.versioning
}


# Provision IAM Policy that grants read access on the CTS OBS bucket of tenants.
module "cts_obs_role" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role"

  roles = [{
    name              = "${var.cts_obs_role.name}-network"
    description       = "${var.cts_obs_role.description} Network"
    type              = var.cts_obs_role.type
    policy      = <<EOF
        {
        "Version": "1.1",
        "Statement": [
                {
                    "Action": [
                        "OBS:*:*"
                    ],
                    "Resource": [
                        "OBS:*:*:bucket:${var.obs_cts_bucket.bucket}-network-${random_string.id.result}",
                        "OBS:*:*:object:*"
                    ],
                    "Effect": "Allow"
                }
            ]
        }
        EOF
   },
   {
    name              = "${var.cts_obs_role.name}-dev"
    description       = "${var.cts_obs_role.description} Dev"
    type              = var.cts_obs_role.type
    policy      = <<EOF
        {
        "Version": "1.1",
        "Statement": [
                {
                    "Action": [
                        "OBS:*:*"
                    ],
                    "Resource": [
                        "OBS:*:*:bucket:${var.obs_cts_bucket.bucket}-dev-${random_string.id.result}",
                        "OBS:*:*:object:*"
                    ],
                    "Effect": "Allow"
                }
            ]
        }
        EOF
   },
   {
    name              = "${var.cts_obs_role.name}-preprod"
    description       = "${var.cts_obs_role.description} PreProd"
    type              = var.cts_obs_role.type
    policy      = <<EOF
        {
        "Version": "1.1",
        "Statement": [
                {
                    "Action": [
                        "OBS:*:*"
                    ],
                    "Resource": [
                        "OBS:*:*:bucket:${var.obs_cts_bucket.bucket}-preprod-${random_string.id.result}",
                        "OBS:*:*:object:*"
                    ],
                    "Effect": "Allow"
                }
            ]
        }
        EOF
   },
   {
    name              = "${var.cts_obs_role.name}-prod"
    description       = "${var.cts_obs_role.description} Prod"
    type              = var.cts_obs_role.type
    policy      = <<EOF
        {
        "Version": "1.1",
        "Statement": [
                {
                    "Action": [
                        "OBS:*:*"
                    ],
                    "Resource": [
                        "OBS:*:*:bucket:${var.obs_cts_bucket.bucket}-prod-${random_string.id.result}",
                        "OBS:*:*:object:*"
                    ],
                    "Effect": "Allow"
                }
            ]
        }
        EOF
   },
   {
    name              = "${var.cts_obs_role.name}-sharedservices"
    description       = "${var.cts_obs_role.description} Shared Services"
    type              = var.cts_obs_role.type
    policy      = <<EOF
        {
        "Version": "1.1",
        "Statement": [
                {
                    "Action": [
                        "OBS:*:*"
                    ],
                    "Resource": [
                        "OBS:*:*:bucket:${var.obs_cts_bucket.bucket}-sharedservices-${random_string.id.result}",
                        "OBS:*:*:object:*"
                    ],
                    "Effect": "Allow"
                }
            ]
        }
        EOF
   }]
}


# Assinging CTS OBS roles to Security tenant. 
# Allow only security tenant to access CTS OBS buckets.
module "cts_obs_role_assignment" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role_assignment"
  role_assignments = [
    {
        group_id   = local.group_ids["security_admin"]
        project_id = local.project_ids[var.network_tenant_name]
        role_id    = module.cts_obs_role.id[0]
    },
    {
        group_id   = local.group_ids["security_admin"]
        project_id = local.project_ids[var.dev_tenant_name]
        role_id    = module.cts_obs_role.id[1]
    },
    {
        group_id   = local.group_ids["security_admin"]
        project_id = local.project_ids[var.preprod_tenant_name]
        role_id    = module.cts_obs_role.id[2]
    },
    {
        group_id   = local.group_ids["security_admin"]
        project_id = local.project_ids[var.prod_tenant_name]
        role_id    = module.cts_obs_role.id[3]
    },
    {
        group_id   = local.group_ids["security_admin"]
        project_id = local.project_ids[var.sharedservices_tenant_name]
        role_id    = module.cts_obs_role.id[4]
    }
    ]
}


# Provision CTS Tracker for Network project
resource "flexibleengine_cts_tracker_v1" "network_tracker" {
  provider = flexibleengine.network_fe
  bucket_name      = "${var.obs_cts_bucket.bucket}-network-${random_string.id.result}"
  depends_on = [ module.obs_cts_bucket_network ]
}
# Provision CTS Tracker for Production project
resource "flexibleengine_cts_tracker_v1" "prod_tracker" {
  provider = flexibleengine.prod_fe
  bucket_name      = "${var.obs_cts_bucket.bucket}-prod-${random_string.id.result}"
  depends_on = [ module.obs_cts_bucket_prod ]
}
# Provision CTS Tracker for PreProd project
resource "flexibleengine_cts_tracker_v1" "preprod_tracker" {
  provider = flexibleengine.preprod_fe
  bucket_name      = "${var.obs_cts_bucket.bucket}-preprod-${random_string.id.result}"
  depends_on = [ module.obs_cts_bucket_preprod ]
}
# Provision CTS Tracker for Dev project
resource "flexibleengine_cts_tracker_v1" "dev_tracker" {
  provider = flexibleengine.dev_fe
  bucket_name      = "${var.obs_cts_bucket.bucket}-dev-${random_string.id.result}"
  depends_on = [ module.obs_cts_bucket_dev ]
}
# Provision CTS Tracker for Shared Services project
resource "flexibleengine_cts_tracker_v1" "shared_tracker" {
  provider = flexibleengine.sharedservices_fe
  bucket_name      = "${var.obs_cts_bucket.bucket}-sharedservices-${random_string.id.result}"
  depends_on = [ module.obs_cts_bucket_shared ]
}



# Provision LTS Prod Group and Topics to collect logs from Hosts.
resource "flexibleengine_lts_group" "lts_prod_hosts_group" {
  provider = flexibleengine.prod_fe
  group_name = var.lts_group_names.prod
}
resource "flexibleengine_lts_topic" "lts_prod_hosts_topic" {
  provider = flexibleengine.prod_fe

  group_id   = flexibleengine_lts_group.lts_prod_hosts_group.id
  topic_name = var.lts_topic_names.prod
}


# Provision LTS PreProd Group and Topics to collect logs from Hosts.
resource "flexibleengine_lts_group" "lts_preprod_hosts_group" {
  provider = flexibleengine.preprod_fe
  group_name = var.lts_group_names.preprod
}
resource "flexibleengine_lts_topic" "lts_preprod_hosts_topic" {
  provider = flexibleengine.preprod_fe

  group_id   = flexibleengine_lts_group.lts_preprod_hosts_group.id
  topic_name = var.lts_topic_names.preprod
}


# Provision LTS Dev Group and Topics to collect logs from Hosts.
resource "flexibleengine_lts_group" "lts_dev_hosts_group" {
  provider = flexibleengine.dev_fe
  group_name = var.lts_group_names.dev
}
resource "flexibleengine_lts_topic" "lts_dev_hosts_topic" {
  provider = flexibleengine.dev_fe

  group_id   = flexibleengine_lts_group.lts_dev_hosts_group.id
  topic_name = var.lts_topic_names.dev
}


# Provision LTS DMZ Group and Topics to collect logs from Hosts.
resource "flexibleengine_lts_group" "lts_network_hosts_group" {
  provider = flexibleengine.network_fe
  group_name = var.lts_group_names.network
}
resource "flexibleengine_lts_topic" "lts_dmz_hosts_topic" {
  provider = flexibleengine.network_fe

  group_id   = flexibleengine_lts_group.lts_network_hosts_group.id
  topic_name = var.lts_topic_names.dmz
}
resource "flexibleengine_lts_topic" "lts_transit_hosts_topic" {
  provider = flexibleengine.network_fe

  group_id   = flexibleengine_lts_group.lts_network_hosts_group.id
  topic_name = var.lts_topic_names.transit
}
resource "flexibleengine_lts_topic" "lts_bastion_hosts_topic" {
  provider = flexibleengine.network_fe

  group_id   = flexibleengine_lts_group.lts_network_hosts_group.id
  topic_name = var.lts_topic_names.bastion
}


# Provision LTS SharedServices Group and Topics to collect logs from Hosts.
resource "flexibleengine_lts_group" "lts_shared_hosts_group" {
  provider = flexibleengine.sharedservices_fe
  group_name = var.lts_group_names.shared
}
resource "flexibleengine_lts_topic" "lts_shared_hosts_topic" {
  provider = flexibleengine.sharedservices_fe

  group_id   = flexibleengine_lts_group.lts_shared_hosts_group.id
  topic_name = var.lts_topic_names.shared
}



/*
Roles To Be checked, if it access across multi tenants.
# ICAgent agency to allow icagent client on ECS hosts access LTS
# You can either, use AK/SK in icagent command or using this agency.
module "icagent_agency" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/agency"

  name                   = "lts_ecm_trust"
  delegated_service_name = "op_svc_ecs"
  tenant_name            = var.security_tenant_name
  roles                  = ["APM Admin"]
  domain_roles = [
    "OBS OperateAccess",
  ]
  duration               = "FOREVER"
}
*/


# Provision CES SMN Topic and Subscriptions for Network tenant
module "ces_smn" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/smn"

  topic_name    = var.ces_smn.topic_name
  topic_display_name = var.ces_smn.topic_display_name
  subscriptions = var.ces_smn.subscriptions
}

# Provision CES rules on firewall instances
module "ces_rules" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/ces"
  alarm_rules = [{
    alarm_name = "firewall1-cpu"

    metric = [{
      namespace   = "SYS.ECS"
      metric_name = "cpu_util"
      dimensions = [{
        name  = "instance_id"
        value = module.ecs_cluster.id[0]
      }]
    }]

    condition = [{
      period              = 1
      filter              = "average"
      comparison_operator = ">="
      value               = 80
      count               = 1
    }]
    
    alarm_actions = [{
      type = "notification"
      notification_list = [
        module.ces_smn.topic_urns[0]
      ]
    }]
  },
  {
    alarm_name = "firewall2-cpu"

    metric = [{
      namespace   = "SYS.ECS"
      metric_name = "cpu_util"
      dimensions = [{
        name  = "instance_id"
        value = module.ecs_cluster.id[1]
      }]
    }]

    condition = [{
      period              = 1
      filter              = "average"
      comparison_operator = ">="
      value               = 80
      count               = 1
    }]
    
    alarm_actions = [{
      type = "notification"
      notification_list = [
        module.ces_smn.topic_urns[0]
      ]
    }]
  },
  {
    alarm_name = "firewall1-mem"

    metric = [{
      namespace   = "SYS.ECS"
      metric_name = "mem_util"
      dimensions = [{
        name  = "instance_id"
        value = module.ecs_cluster.id[0]
      }]
    }]

    condition = [{
      period              = 1
      filter              = "average"
      comparison_operator = ">="
      value               = 80
      count               = 1
    }]
    
    alarm_actions = [{
      type = "notification"
      notification_list = [
        module.ces_smn.topic_urns[0]
      ]
    }]
  },
  {
    alarm_name = "firewall2-mem"

    metric = [{
      namespace   = "SYS.ECS"
      metric_name = "mem_util"
      dimensions = [{
        name  = "instance_id"
        value = module.ecs_cluster.id[1]
      }]
    }]

    condition = [{
      period              = 1
      filter              = "average"
      comparison_operator = ">="
      value               = 80
      count               = 1
    }]
    
    alarm_actions = [{
      type = "notification"
      notification_list = [
        module.ces_smn.topic_urns[0]
      ]
    }]
  }
  ]
}