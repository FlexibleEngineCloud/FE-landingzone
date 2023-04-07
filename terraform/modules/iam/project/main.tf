# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_identity_project_v3" "project" {
  for_each = toset(var.projects)

  name        = "${var.region}_${each.value}"
  description = "${each.value} project"
}