# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}
# Configuration of FE provider
provider "flexibleengine" {
  access_key  = var.ak
  secret_key  = var.sk
  domain_name = var.domain_name
  tenant_name = var.tenant_name
  region      = var.region
  auth_url    = "https://iam.eu-west-1.prod-cloud-ocb.orange-business.com/v3"
}