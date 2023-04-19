# Provision projects
module "iam_projects" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/project"

  project_names = local.project_names
  region        = var.region
}