locals {
  projects = [
    "Network",
    "Security_Management",
    "Database",
    "App_Dev",
    "Shared_Services"
  ]

  users = {
    abdel = "baf1dc435a634040840cf85537a2951a",
    pierre = "4d24963753a344609cc188da1b679563",
    vincent = "41e437b403404796af1c5cde52b25aca",
    jean-luc = "0010b70791cc4e0ca1d553f265772fcc"
  }

  groups = {
    admins = ["abdel","vincent"],
    network = ["pierre"],
    security = ["vincent"],
    database = ["jean-luc"],
    appdev = ["abdel","jean-luc","pierre"]
  }
}