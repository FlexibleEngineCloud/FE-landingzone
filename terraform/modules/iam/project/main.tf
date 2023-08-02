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


// Locals that return project IDs instead of creating them above, 
// Project deletion requires double authentification confirmation, 
// Which interrupt landing zone testing.
// Storing Project IDs in this local could help in testing the landing zone.
locals {
  groups_ids = tomap({
  "eu-west-0_Netowrk2" = "ba6bd16799774025ace364715b2e08e6"
  "eu-west-0_Security_Management2" = "3c453a2a429a4eafad1fc54db8c8f55d"
  "eu-west-0_Shared_Services2" = "803f4d368bd849878cd409e2676e18ae"
  "eu-west-0_Dev2" = "057bceb65d7844cc8c2cc36a18aef48f"
  "eu-west-0_PreProd2" = "bc3ce81c822b4486bb5428ef8f0feaf1"
  "eu-west-0_Prod2" = "ce6b52a3710d4ea28eb45f637930db7a"
  })
}