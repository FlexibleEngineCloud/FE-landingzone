# Provision CTS OBS Bucket
module "obs_cts_bucket" {
  providers = {
    flexibleengine = flexibleengine.security_fe
  }

  source = "../modules/obs"

  bucket = "bucket-cts-landingzone-${random_string.id.result}"
  acl    = "private"

  encryption    = false
  versioning = true
}

# Provision IAM Policy that grants read access on the CTS OBS bucket.
module "cts_obs_role" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role"

  roles = [{
    name              = "delegate-cts-obs"
    description       = "Delegate access on CTS OBS bucket"
    type              = "AX"
    policy            = <<EOF
        {
        "Version": "1.1",
        "Statement": [
                {
                    "Action": [
                        "OBS:*:*"
                    ],
                    "Resource": [
                        "OBS:*:*:bucket:bucket-cts-landingzone-${random_string.id.result}",
                        "OBS:*:*:object:*"
                    ],
                    "Effect": "Allow"
                }
            ]
        }
        EOF
   }]
}


# Assinging CTS OBS role to Security tenant. 
# Allow only security tenant to access CTS OBS bucket.
module "cts_obs_role_assignment" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role_assignment"
  role_assignments = [
    {
        group_id   = local.group_ids["security"]
        project_id = local.project_ids[var.security_tenant_name]
        role_id    = module.cts_obs_role.id[0]
    }]
}


# Provision CTS Tracker for Home project
resource "flexibleengine_cts_tracker_v1" "home_tracker" {
  provider = flexibleengine.home_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
  depends_on = [ module.obs_cts_bucket ]
}
# Provision CTS Tracker for Security project
resource "flexibleengine_cts_tracker_v1" "security_tracker" {
  provider = flexibleengine.security_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
  depends_on = [ module.obs_cts_bucket ]
}
# Provision CTS Tracker for Network project
resource "flexibleengine_cts_tracker_v1" "network_tracker" {
  provider = flexibleengine.network_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
depends_on = [ module.obs_cts_bucket ]
}
# Provision CTS Tracker for Production project
resource "flexibleengine_cts_tracker_v1" "prod_tracker" {
  provider = flexibleengine.prod_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
depends_on = [ module.obs_cts_bucket ]
}
# Provision CTS Tracker for PreProd project
resource "flexibleengine_cts_tracker_v1" "preprod_tracker" {
  provider = flexibleengine.preprod_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
depends_on = [ module.obs_cts_bucket ]
}
# Provision CTS Tracker for Dev project
resource "flexibleengine_cts_tracker_v1" "dev_tracker" {
  provider = flexibleengine.dev_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
depends_on = [ module.obs_cts_bucket ]
}
# Provision CTS Tracker for Shared Services project
resource "flexibleengine_cts_tracker_v1" "shared_tracker" {
  provider = flexibleengine.sharedservices_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
depends_on = [ module.obs_cts_bucket ]
}


# Provision LTS Group and Topics to collect logs from Hosts.
resource "flexibleengine_lts_group" "lts_hosts_group" {
  provider = flexibleengine.security_fe
  group_name = "Hosts"
}
resource "flexibleengine_lts_topic" "lts_prod_hosts_topic" {
  provider = flexibleengine.security_fe

  group_id   = flexibleengine_lts_group.lts_hosts_group.id
  topic_name = "Prod_Hosts_Topic"
}
resource "flexibleengine_lts_topic" "lts_dev_hosts_topic" {
  provider = flexibleengine.security_fe

  group_id   = flexibleengine_lts_group.lts_hosts_group.id
  topic_name = "Dev_Hosts_Topic"
}
resource "flexibleengine_lts_topic" "lts_dmz_hosts_topic" {
  provider = flexibleengine.security_fe

  group_id   = flexibleengine_lts_group.lts_hosts_group.id
  topic_name = "DMZ_Hosts_Topic"
}
resource "flexibleengine_lts_topic" "lts_bastion_hosts_topic" {
  provider = flexibleengine.security_fe

  group_id   = flexibleengine_lts_group.lts_hosts_group.id
  topic_name = "Bastion_Hosts_Topic"
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


