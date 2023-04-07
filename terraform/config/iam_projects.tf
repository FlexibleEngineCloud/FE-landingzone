module "iam_projects" {
  source = "../modules/iam/project"
  projects = local.projects
  region = var.region

  providers = {
    flexibleengine = flexibleengine.fe
  }
}