output "sso_user_ids" {
  value = {
    for k, u in aws_identitystore_user.user :
    k => u.user_id
  }
}

output "sso_groups" {
  value = {
    for k, g in aws_identitystore_group.group :
    k => g.group_id
  }
}

output "aws_access_portal_url" {
  value = local.aws_access_portal_url
}
