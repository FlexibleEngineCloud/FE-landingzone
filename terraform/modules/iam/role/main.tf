# Role Assgnments Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

# Provision Role resource
resource "flexibleengine_identity_role_v3" "role" {
  count = length(var.roles)

  name = var.roles[count.index]["name"]
  description = var.roles[count.index]["description"]
  type = var.roles[count.index]["type"]
  policy = var.roles[count.index]["policy"]
}