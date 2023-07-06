// OBS CTS Bucket ID
output "bucket_id" {
  description = "The name of the bucket."
  value       = module.obs_cts_bucket.id
}
