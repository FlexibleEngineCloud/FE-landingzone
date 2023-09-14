# Role Assignments variable
variable "role_assignments" {
  type = list(object({
    group_id   = string
    project_id = optional(string)
    domain_id = optional(string)
    role_id    = string
  }))
}