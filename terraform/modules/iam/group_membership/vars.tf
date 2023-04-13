variable "groups" {
  type = list(object({
    name    = string
    users   = list(object({
      name = string
      id   = string
    }))
    projects = list(object({
      name        = string
      permissions = list(string)
    }))
  }))
}

variable "groups_ids" {
  type = map(string)
}
