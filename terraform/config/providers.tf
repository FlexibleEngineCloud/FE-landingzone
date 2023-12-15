# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

# Configuration of Global FE provider
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

# Configuration of FE provider for Prod tenant.
provider "flexibleengine" {
  alias = "prod_fe"
  access_key  = var.ak
  secret_key  = var.sk
  domain_name = var.domain_name
  tenant_name = var.prod_tenant_name
  region      = var.region
  auth_url    = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"
}

# Configuration of FE provider for PreProd tenant.
provider "flexibleengine" {
  alias = "preprod_fe"
  access_key  = var.ak
  secret_key  = var.sk
  domain_name = var.domain_name
  tenant_name = var.preprod_tenant_name
  region      = var.region
  auth_url    = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"
}

# Configuration of FE provider for Dev tenant.
provider "flexibleengine" {
  alias = "dev_fe"
  access_key  = var.ak
  secret_key  = var.sk
  domain_name = var.domain_name
  tenant_name = var.dev_tenant_name
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
