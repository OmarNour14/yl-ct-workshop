resource "aws_identitystore_user" "user" {
  for_each = var.users

  identity_store_id = var.identity_store_id
  display_name      = each.value.display_name
  user_name         = each.value.user_principal_name

  name {
    given_name  = each.value.given_name
    family_name = each.value.surname
  }

  emails {
    value   = each.value.email
    primary = true
  }
}
