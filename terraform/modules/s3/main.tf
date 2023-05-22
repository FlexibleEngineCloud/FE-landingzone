# VPC Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

// S3 Bucket
resource "flexibleengine_s3_bucket" "bucket" {
  count = var.create_bucket ? 1 : 0

  bucket        = var.bucket
  bucket_prefix = var.bucket_prefix
  policy = var.policy

  acl = var.acl != "null" ? var.acl : null

  force_destroy = var.force_destroy

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

  dynamic "versioning" {
    for_each = length(keys(var.versioning)) == 0 ? [] : [var.versioning]

    content {
      enabled = lookup(versioning.value, "enabled", null)
      mfa_delete = lookup(versioning.value, "mfa_delete", null)
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule

    content {
      id    = lookup(lifecycle_rule.value, "id", null)
      prefix  = lookup(lifecycle_rule.value, "prefix", null)
      enabled = lifecycle_rule.value.enabled
      abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)

      # Max 1 block - expiration
      dynamic "expiration" {
        for_each = length(keys(lookup(lifecycle_rule.value, "expiration", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "expiration", {})]

        content {
          date = lookup(expiration.value, "date", null)
          days = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }

      # Max 1 block - noncurrent_version_expiration
      dynamic "noncurrent_version_expiration" {
        for_each = length(keys(lookup(lifecycle_rule.value, "noncurrent_version_expiration", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "noncurrent_version_expiration", {})]

        content {
          days = lookup(noncurrent_version_expiration.value, "days", null)
        }
      }
    }
  }
}

// S3 Bucket policy to apply to S3 bucket
resource "flexibleengine_s3_bucket_policy" "policy" {
  count = var.create_bucket && var.attach_policy ? 1 : 0

  bucket = flexibleengine_s3_bucket.bucket[0].id
  policy = var.policy

  depends_on = [ flexibleengine_s3_bucket.bucket ]
}


// S3 Bucket objects
resource "flexibleengine_s3_bucket_object" "objects" {
  count  = length(var.objects)
  bucket = flexibleengine_s3_bucket.bucket[0].id
  key    = element(var.objects.*.key, count.index) == null ? null : element(var.objects.*.key, count.index)
  //server_side_encryption = element(var.objects.*.server_side_encryption, count.index) == null ? null : element(var.objects.*.server_side_encryption, count.index)
  //acl = element(var.objects.*.acl, count.index) == null ? null : element(var.objects.*.acl, count.index)
  
  //cache_control = element(var.objects.*.cache_control, count.index) == null ? null : element(var.objects.*.cache_control, count.index)
  //content_disposition = element(var.objects.*.content_disposition, count.index) == null ? null : element(var.objects.*.content_disposition, count.index)
  //content_encoding = element(var.objects.*.content_encoding, count.index) == null ? null : element(var.objects.*.content_encoding, count.index)
  //content_language = element(var.objects.*.content_language, count.index) == null ? null : element(var.objects.*.content_language, count.index)
  //website_redirect = element(var.objects.*.website_redirect, count.index) == null ? null : element(var.objects.*.website_redirect, count.index)

  //etag = element(var.objects.*.etag, count.index) == null ? null : element(var.objects.*.etag, count.index)

  //source = element(var.objects.*.source, count.index) == null ? null : element(var.objects.*.source, count.index)

  content = element(var.objects.*.content, count.index) == null ? null : element(var.objects.*.content, count.index)
  //content_type = element(var.objects.*.content_type, count.index) == null ? null : element(var.objects.*.content_type, count.index)

  depends_on = [ flexibleengine_s3_bucket.bucket ]
} 