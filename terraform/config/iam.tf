# Provision User Groups
module "iam_groups" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/user_group"

  group_names = local.group_names
}

# Provision Group Memberships
module "group_membership" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/group_membership"

  group_membership = local.group_membership

  depends_on = [
    module.iam_groups
  ]
}

# Assinging Roles module
module "iam_roles" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role_assignment"

  role_assignments = local.role_assignments

  depends_on = [
    module.group_membership
  ]
}

# Provision IAM Policy that grants enhanced read access on all OBS buckets.
module "OBS_bucket_viewer_enhanced_role" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role"

  roles = [{
    name              = "obs-bucket-viewer-enhanced"
    description       = "Read access on OBS"
    type              = "AX"
    policy      = <<EOF
        {
        "Version": "1.1",
        "Statement": [
                {
                    "Action": [
                        "OBS:bucket:Get*",
                        "OBS:bucket:ListAllMyBuckets",
                        "OBS:bucket:HeadBucket"
                    ],
                    "Resource": [
                        "OBS:*:*:bucket:*",
                        "OBS:*:*:object:*"
                    ],
                    "Effect": "Allow"
                }
            ]
        }
        EOF
   }
   ]
}

module "OBS_bucket_viewer_role_assignment" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role_assignment"
  role_assignments = [
    {
        group_id   = local.group_ids["domain_admin"]
        domain_id = var.domain_id
        role_id    = module.OBS_bucket_viewer_enhanced_role.id[0]
    },
    {
        group_id   = local.group_ids["network_admin"]
        domain_id = var.domain_id
        role_id    = module.OBS_bucket_viewer_enhanced_role.id[0]
    },
    {
        group_id   = local.group_ids["dev_admin"]
        domain_id = var.domain_id
        role_id    = module.OBS_bucket_viewer_enhanced_role.id[0]
    },
    {
        group_id   = local.group_ids["preprod_admin"]
        domain_id = var.domain_id
        role_id    = module.OBS_bucket_viewer_enhanced_role.id[0]
    },
    {
        group_id   = local.group_ids["prod_admin"]
        domain_id = var.domain_id
        role_id    = module.OBS_bucket_viewer_enhanced_role.id[0]
    }
    ]
}

# Assinging 'FullAccess' and 'OBS FullAccess' to super_admin
module "fullaccess_role_assignment" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role_assignment"
  role_assignments = [
    {
        group_id   = local.group_ids["super_admin"]
        domain_id = var.domain_id
        role_id    = "9287ee3e297a41249ef85500a2f4e7d4"
    },
    {
        group_id   = local.group_ids["super_admin"]
        domain_id = var.domain_id
        role_id    = "7e573fea4da7427d8ca3d41e699290d7"
    }]
}

# Assinging 'Security Administrator' role to security_admin
module "global_role_assignment_security" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role_assignment"
  role_assignments = [
    {
        group_id   = local.group_ids["security_admin"]
        domain_id = var.domain_id
        role_id    = "4b6459d7a68f45f0b3cf7682c21c57e2"
    }]
}


# Assinging 'Global' roles to domain_admin
# 'TMS admin', 'IAM RO', 'OBS Full Accces'
module "global_role_assignment_domain" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role_assignment"
  role_assignments = [
    {
        group_id   = local.group_ids["domain_admin"]
        domain_id = var.domain_id
        role_id    = "0cd3367cdca345a7aa8607b9d1645232"
    },
    {
        group_id   = local.group_ids["domain_admin"]
        domain_id = var.domain_id
        role_id    = "51e89a12ca524205addb639ca85adcc8"
    },
    {
        group_id   = local.group_ids["domain_admin"]
        domain_id = var.domain_id
        role_id    = "7e573fea4da7427d8ca3d41e699290d7"
    }]
}

# Assinging 'Global' roles to network_admin
# 'IAM RO', 'OBS Full Accces'
module "global_role_assignment_network" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role_assignment"
  role_assignments = [
    {
        group_id   = local.group_ids["network_admin"]
        domain_id = var.domain_id
        role_id    = "51e89a12ca524205addb639ca85adcc8"
    },
    {
        group_id   = local.group_ids["network_admin"]
        domain_id = var.domain_id
        role_id    = "7e573fea4da7427d8ca3d41e699290d7"
    }]
}

# Assinging 'Global' roles to dev_admin
# 'IAM RO', 'OBS Full Accces'
module "global_role_assignment_dev" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role_assignment"
  role_assignments = [
    {
        group_id   = local.group_ids["dev_admin"]
        domain_id = var.domain_id
        role_id    = "51e89a12ca524205addb639ca85adcc8"
    },
    {
        group_id   = local.group_ids["dev_admin"]
        domain_id = var.domain_id
        role_id    = "7e573fea4da7427d8ca3d41e699290d7"
    }]
}

# Assinging 'Global' roles to preprod_admin
# 'IAM RO', 'OBS Full Accces'
module "global_role_assignment_preprod" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role_assignment"
  role_assignments = [
    {
        group_id   = local.group_ids["preprod_admin"]
        domain_id = var.domain_id
        role_id    = "51e89a12ca524205addb639ca85adcc8"
    },
    {
        group_id   = local.group_ids["preprod_admin"]
        domain_id = var.domain_id
        role_id    = "7e573fea4da7427d8ca3d41e699290d7"
    }]
}

# Assinging 'Global' roles to prod_admin
# 'TMS admin', 'IAM RO', 'OBS Full Accces'
module "global_role_assignment_prod" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role_assignment"
  role_assignments = [
    {
        group_id   = local.group_ids["prod_admin"]
        domain_id = var.domain_id
        role_id    = "51e89a12ca524205addb639ca85adcc8"
    },
    {
        group_id   = local.group_ids["prod_admin"]
        domain_id = var.domain_id
        role_id    = "7e573fea4da7427d8ca3d41e699290d7"
    }]
}