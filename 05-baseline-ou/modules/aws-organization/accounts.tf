resource "aws_organizations_account" "accounts" {
  for_each = var.organization_accounts

  name              = each.value.name
  email             = each.value.email
  close_on_deletion = true
  parent_id         = each.value.ou != null ? aws_organizations_organizational_unit.ou[each.value.ou].id : data.aws_organizations_organization.org.roots[0].id
  lifecycle {
    ignore_changes = [parent_id]
  }
}
