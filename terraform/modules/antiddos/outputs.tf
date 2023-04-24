output "ids" {
  description = "AntiDDOS protection IDs"
  value       = [for antiddos in flexibleengine_antiddos_v1.antiddos : antiddos.id] 
}
