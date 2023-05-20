# VPC Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

// KMS key
data "flexibleengine_kms_key_v1" "key" {
  count     = var.kms_key_alias == null ? 0 : 1
  key_alias = var.kms_key_alias
}

// OBS Bucket
resource "flexibleengine_obs_bucket" "bucket" {
  count = var.create_bucket ? 1 : 0

  bucket        = var.bucket
  storage_class = var.storage_class

  versioning = var.versioning

  acl = var.acl != "null" ? var.acl : null

  multi_az = var.multi_az

  force_destroy = var.force_destroy

  encryption = var.encryption

  // if not existing KMS, create one
  kms_key_id = var.kms_key_alias == null ? null : data.flexibleengine_kms_key_v1.key[0].id

  dynamic "website" {
    for_each = length(keys(var.website)) == 0 ? [] : [var.website]

    content {
      index_document           = website.value.index_document
      error_document           = lookup(website.value, "error_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules            = lookup(website.value, "routing_rules", null)
    }
  }

  dynamic "cors_rule" {
    for_each = var.cors_rule

    content {
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", 100)
    }
  }

  dynamic "logging" {
    for_each = length(keys(var.logging)) == 0 ? [] : [var.logging]

    content {
      target_bucket = logging.value.target_bucket
      target_prefix = lookup(logging.value, "target_prefix", null)
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule

    content {
      name    = lookup(lifecycle_rule.value, "name", null)
      prefix  = lookup(lifecycle_rule.value, "prefix", null)
      enabled = lifecycle_rule.value.enabled

      # Max 1 block - expiration
      dynamic "expiration" {
        for_each = length(keys(lookup(lifecycle_rule.value, "expiration", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "expiration", {})]

        content {
          days = lookup(expiration.value, "days", null)
        }
      }

      dynamic "transition" {
        for_each = length(keys(lookup(lifecycle_rule.value, "transition", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "transition", {})]

        content {
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }

      # Max 1 block - noncurrent_version_expiration
      dynamic "noncurrent_version_expiration" {
        for_each = length(keys(lookup(lifecycle_rule.value, "noncurrent_version_expiration", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "noncurrent_version_expiration", {})]

        content {
          days = lookup(noncurrent_version_expiration.value, "days", null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = length(keys(lookup(lifecycle_rule.value, "noncurrent_version_transition", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "noncurrent_version_transition", {})]

        content {
          days          = lookup(noncurrent_version_transition.value, "days", null)
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }
}

// S3 Bucket policy to apply to OBS bucket
resource "flexibleengine_s3_bucket_policy" "policy" {
  count = var.create_bucket && var.attach_policy ? 1 : 0

  bucket = flexibleengine_obs_bucket.bucket[0].id
  policy = var.policy
}

// OBS Bucket notifications
// SMN topic must has agency to allow OBS
// https://docs.prod-cloud-ocb.orange-business.com/en-us/usermanual/smn/en-us_topic_0043394891.html
resource "flexibleengine_obs_bucket_notifications" "notifications" {
  count  = length(var.notifications)
  bucket = flexibleengine_obs_bucket.bucket[0].id

  notifications {
    name      = element(var.notifications.*.name, count.index) == null ? null : element(var.notifications.*.name, count.index)
    events    = element(var.notifications.*.events, count.index) == null ? null : element(var.notifications.*.events, count.index)
    prefix    = element(var.notifications.*.prefix, count.index) == null ? null : element(var.notifications.*.prefix, count.index)
    suffix    = element(var.notifications.*.suffix, count.index) == null ? null : element(var.notifications.*.suffix, count.index)
    topic_urn = element(var.notifications.*.topic_urn, count.index) == null ? null : element(var.notifications.*.topic_urn, count.index)
  }
}

// OBS bucket replica
resource "flexibleengine_obs_bucket_replication" "replica" {
  count = var.create_replica ? 1 : 0

  bucket             = element(var.replica.*.bucket, count.index) == null ? null : element(var.replica.*.bucket, count.index)
  destination_bucket = element(var.replica.*.destination_bucket, count.index) == null ? null : element(var.replica.*.destination_bucket, count.index)
  agency             = element(var.replica.*.agency, count.index) == null ? null : element(var.replica.*.agency, count.index)

  dynamic "rule" {
    for_each = var.replica[count.index].rules

    content {
      enabled       = lookup(rule.value, "enabled", null)
      prefix        = lookup(rule.value, "prefix", null)
      storage_class = lookup(rule.value, "storage_class", null)
    }
  }
}
