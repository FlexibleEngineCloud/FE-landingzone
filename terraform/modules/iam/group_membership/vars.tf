# Group membership variable
variable "group_membership" {
  type = map(object({
    group_id = string
    user_ids = list(string)
  }))
}