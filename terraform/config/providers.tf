# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

# Configuration of Home FE provider
provider "flexibleengine" {
  alias       = "home_fe"
  access_key  = var.ak
  secret_key  = var.sk
  domain_name = var.domain_name
  tenant_name = var.tenant_name
  region      = var.region
  auth_url    = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"
}

# Configuration of FE provider for Network tenant.
provider "flexibleengine" {
  alias = "network_fe"
  access_key  = var.ak
  secret_key  = var.sk
  domain_name = var.domain_name
  tenant_name = var.network_tenant_name
  region      = var.region
  auth_url    = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"
}

# Configuration of FE provider for Security tenant.
provider "flexibleengine" {
  alias = "security_fe"
  access_key  = var.ak
  secret_key  = var.sk
  domain_name = var.domain_name
  tenant_name = var.security_tenant_name
  region      = var.region
  auth_url    = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"
}

# Configuration of FE provider for Database tenant.
provider "flexibleengine" {
  alias = "database_fe"
  access_key  = var.ak
  secret_key  = var.sk
  domain_name = var.domain_name
  tenant_name = var.database_tenant_name
  region      = var.region
  auth_url    = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"
}

# Configuration of FE provider for AppDev tenant.
provider "flexibleengine" {
  alias = "appdev_fe"
  access_key  = var.ak
  secret_key  = var.sk
  domain_name = var.domain_name
  tenant_name = var.appdev_tenant_name
  region      = var.region
  auth_url    = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"
}

# Configuration of FE provider for Shared Services tenant.
provider "flexibleengine" {
  alias = "sharedservices_fe"
  access_key  = var.ak
  secret_key  = var.sk
  domain_name = var.domain_name
  tenant_name = var.sharedservices_tenant_name
  region      = var.region
  auth_url    = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"
}