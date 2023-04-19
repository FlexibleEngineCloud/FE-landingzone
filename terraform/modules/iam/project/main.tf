# Projects Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

/*
# Provision Project resource
resource "flexibleengine_identity_project_v3" "project" {
  for_each = toset(var.project_names)

  name        =  length(regexall(var.region, each.value)) > 0 ? "${each.value}" : "${var.region}_${each.value}"
  description = length(regexall(var.region, each.value)) > 0 ? "${each.value} project" : "${var.region}_${each.value} project"

  # any other attributes you need to set for each project
}
*/

locals {
  groups_ids = tomap({
  "eu-west-0_App_Dev2" = "d103489520c84126ad81b359aa56818a"
  "eu-west-0_Database2" = "dda5ef70b0ce4586a75de64b722b8ad6"
  "eu-west-0_Netowrk2" = "ba6bd16799774025ace364715b2e08e6"
  "eu-west-0_Security_Management2" = "3c453a2a429a4eafad1fc54db8c8f55d"
  "eu-west-0_Shared_Services2" = "803f4d368bd849878cd409e2676e18ae"
  })
}