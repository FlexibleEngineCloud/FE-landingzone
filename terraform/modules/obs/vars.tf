variable "create_bucket" {
  description = "Controls if OBS bucket should be created"
  type        = bool
  default     = true
}

variable "attach_policy" {
  description = "Controls if OBS bucket should have bucket policy attached (set to `true` to use value of `policy` as bucket policy)"
  type        = bool
  default     = false
}

variable "bucket" {
  description = "(Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "storage_class" {
  description = "(Optional) pecifies the storage class of the bucket. OBS provides three storage classes: STANDARD, STANDARD_IA (Infrequent Access) and GLACIER (Archive). Defaults to STANDARD."
  type        = string
  default     = null
}

variable "bucket_prefix" {
  description = "(Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."
  type        = string
  default     = null
}

variable "acl" {
  description = "(Optional) The canned ACL to apply. Defaults to 'private'. Conflicts with `grant`"
  type        = string
  default     = "private"
}

variable "policy" {
  description = "(Optional) A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "website" {
  description = "Map containing static web-site hosting or redirect configuration."
  type        = map(string)
  default     = {}
}

variable "cors_rule" {
  description = "List of maps containing rules for Cross-Origin Resource Sharing."
  type        = any
  default     = []
}

variable "versioning" {
  description = "Versioning configuration (True/False)."
  type        = bool
  default     = false
}

variable "logging" {
  description = "Map containing access bucket logging configuration."
  type        = map(string)
  default     = {}
}

variable "lifecycle_rule" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []
}

variable "encryption" {
  description = "Encryption configuration (True/False)."
  type        = bool
  default     = false
}

variable "kms_key_alias" {
  description = "Alias of existing KMS key used for encryption"
  type        = string
  default     = null
}


variable "multi_az" {
  description = "Enable cross availabilities zones replication"
  type        = bool
  default     = false
}