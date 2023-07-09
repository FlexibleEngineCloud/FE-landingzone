# User Groups Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_identity_agency_v3" "agency" {
  name                   = var.name
  description            = "${var.name} agency created by Terraform"
  
  # Use a conditional expression to set the value of delegated_service_name
  # or delegated_domain_name based on the presence of the corresponding variable.
  delegated_service_name = var.delegated_service_name != null ? var.delegated_service_name : null
  #delegated_domain_name = var.delegated_domain_name != null ? var.delegated_domain_name : null
  
  duration = var.duration != null ? var.duration : null

  project_role {
    project = var.tenant_name != null ? var.tenant_name : null
    roles = var.roles != null ? var.roles : null
  }
  domain_roles = var.domain_roles != null ? var.domain_roles : null

  /*
  # If both variables are set, Terraform will throw an error.
  validation {
    condition     = var.delegated_service_name != null && var.delegated_domain_name != null
    error_message = "Only one of 'delegated_service_name' or 'delegated_domain_name' can be set."
  }
  validation {
    # Use a condition to check if the duration variable is set to either FOREVER or ONEDAY.
    # If the duration is not set to one of these values, Terraform will throw an error.
    condition     = var.duration == "FOREVER" || var.duration == "ONEDAY"
    error_message = "The 'duration' variable must be set to either 'FOREVER' or 'ONEDAY'."
  }
  */
}

