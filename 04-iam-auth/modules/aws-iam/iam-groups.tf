resource "aws_identitystore_group" "group" {
  for_each = var.roles

  identity_store_id = var.identity_store_id
  display_name      = title(each.key)
  description       = "${title(each.key)} group for access management."
}

resource "aws_identitystore_group_membership" "membership" {
  for_each = {
    for user_key, user in var.users :
    "${user_key}-${user.role}" => {
      user_key = user_key
      role     = user.role
    }
  }

  identity_store_id = var.identity_store_id
  group_id          = aws_identitystore_group.group[each.value.role].group_id
  member_id         = aws_identitystore_user.user[each.value.user_key].user_id
}
