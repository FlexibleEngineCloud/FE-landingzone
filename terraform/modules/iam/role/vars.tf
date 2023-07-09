# Roles variable
variable "roles" {
  description = "List of maps containing IAM roles"
  type = list(object({
    name   = string
    description = string
    type    = string
    policy    = string
  }))
}