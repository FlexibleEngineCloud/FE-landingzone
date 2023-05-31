// SFS file systems shares outputs
output "sfs_ids" {
  description = "SFS shares IDs"
  value       = [for sfs in flexibleengine_sfs_file_system_v2.sfs : sfs.id] 
}
output "sfs" {
  description = "SFS shares detailed"
  value       = [for sfs in flexibleengine_sfs_file_system_v2.sfs : sfs] 
}

// SFS Turbo outputs
output "sfs_turbo_ids" {
  description = "SFS Turbo IDs"
  value       = [for sfs_turbo in flexibleengine_sfs_turbo.sfs_turbos : sfs_turbo.id] 
}
output "sfs_turbos" {
  description = "SFS Turbo detailed"
  value       = [for sfs_turbo in flexibleengine_sfs_turbo.sfs_turbos : sfs_turbo] 
}