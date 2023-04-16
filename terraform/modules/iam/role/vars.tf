# Role Assignments variable
variable "role_assignments" {
  type = list(object({
    group_id   = string
    project_id = string
    role_id    = string
  }))
}