resource "aws_ssoadmin_permission_set" "role" {
  for_each = var.roles

  instance_arn = var.sso_instance_arn
  name         = title(each.key)
  description  = "${title(each.key)} role for SSO."
}

resource "aws_ssoadmin_managed_policy_attachment" "role_attachment" {
  for_each = var.roles

  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.role[each.key].arn
  managed_policy_arn = var.role_policies[each.key]
}

resource "aws_ssoadmin_account_assignment" "assignment" {
  for_each = var.roles

  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.role[each.key].arn
  principal_type     = "GROUP"
  principal_id       = aws_identitystore_group.group[each.key].group_id
  target_type        = "AWS_ACCOUNT"
  target_id          = var.aws_account_id
}
