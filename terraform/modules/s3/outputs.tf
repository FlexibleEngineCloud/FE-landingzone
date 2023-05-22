output "id" {
  description = "The name of the bucket."
  value       = element(concat(flexibleengine_s3_bucket.bucket.*.id, [""]), 0)
}

output "domain_name" {
  description = "The bucket domain name. Will be of format <bucket-name>.oss.<region>.prod-cloud-ocb.orange-business.com."
  value       = element(concat(flexibleengine_s3_bucket.bucket.*.bucket_domain_name, [""]), 0)
}

output "region" {
  description = "The Flexible Engine region this bucket resides in."
  value       = element(concat(flexibleengine_s3_bucket.bucket.*.region, [""]), 0)
}

output "bucket_details" {
  description = "The Flexible Engine bucket details"
  value       = [for bucket in flexibleengine_s3_bucket.bucket : bucket]
}

output "bucket_objects" {
  description = "The Flexible Engine bucket objects"
  value       = [for obj in flexibleengine_s3_bucket_object.objects : obj]
}