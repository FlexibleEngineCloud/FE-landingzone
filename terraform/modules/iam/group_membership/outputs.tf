output "group_memberships" {
  description = "maps containing the group name and the user IDs of the created memebership"
  value = {
    for membership in flexibleengine_identity_group_membership_v3.membership :
      membership.group => [ membership.users ]
  }
}