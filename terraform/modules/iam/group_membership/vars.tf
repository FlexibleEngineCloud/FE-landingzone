# Groups variable
variable "groups" {
  type = list(object({
    name = string
    users = list(object({
      name = string
      id   = string
    }))
    projects = list(object({
      name        = string
      permissions = list(string)
    }))
  }))
}

# Groups IDs variable
variable "groups_ids" {
  type = map(string)
}
