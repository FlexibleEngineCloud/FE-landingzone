# Provision CTS OBS Bucket
module "obs_cts_bucket" {
  providers = {
    flexibleengine = flexibleengine.security_fe
  }

  source = "../modules/obs"

  bucket = "bucket-cts-landingzone-${random_string.id.result}"
  acl    = "private"

  encryption    = false
  versioning = true
}

# Provision CTS Tracker for Home project
resource "flexibleengine_cts_tracker_v1" "home_tracker" {
  provider = flexibleengine.home_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
  depends_on = [ module.obs_cts_bucket ]
}
# Provision CTS Tracker for Security project
resource "flexibleengine_cts_tracker_v1" "security_tracker" {
  provider = flexibleengine.security_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
  depends_on = [ module.obs_cts_bucket ]
}
# Provision CTS Tracker for Network project
resource "flexibleengine_cts_tracker_v1" "network_tracker" {
  provider = flexibleengine.network_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
depends_on = [ module.obs_cts_bucket ]
}
# Provision CTS Tracker for Production project
resource "flexibleengine_cts_tracker_v1" "prod_tracker" {
  provider = flexibleengine.prod_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
depends_on = [ module.obs_cts_bucket ]
}
# Provision CTS Tracker for PreProd project
resource "flexibleengine_cts_tracker_v1" "preprod_tracker" {
  provider = flexibleengine.preprod_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
depends_on = [ module.obs_cts_bucket ]
}
# Provision CTS Tracker for Dev project
resource "flexibleengine_cts_tracker_v1" "dev_tracker" {
  provider = flexibleengine.dev_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
depends_on = [ module.obs_cts_bucket ]
}
# Provision CTS Tracker for Shared Services project
resource "flexibleengine_cts_tracker_v1" "shared_tracker" {
  provider = flexibleengine.sharedservices_fe
  bucket_name      = "bucket-cts-landingzone-${random_string.id.result}"
depends_on = [ module.obs_cts_bucket ]
}
