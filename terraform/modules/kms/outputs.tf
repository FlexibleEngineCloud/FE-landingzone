output "id" {
    value       = flexibleengine_kms_key_v1.kms.id
    description = "The globally unique identifier for the key"
}

output "key" {
    value       = flexibleengine_kms_key_v1.kms
    description = "KMS attributes"
}