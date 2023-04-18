# Projects Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}


# Provision Project resource
resource "flexibleengine_identity_project_v3" "project" {
  for_each = toset(var.project_names)

  name        =  length(regexall(var.region, each.value)) > 0 ? "${each.value}" : "${var.region}_${each.value}"
  description = length(regexall(var.region, each.value)) > 0 ? "${each.value} project" : "${var.region}_${each.value} project"

  # any other attributes you need to set for each project
}