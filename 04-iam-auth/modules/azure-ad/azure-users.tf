resource "random_password" "user_passwords" {
  for_each    = { for k, v in var.users : k => v if v.azure_ad_user_type == "Member" }
  length      = 16
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
}

resource "azuread_user" "user" {
  for_each = { for k, v in var.users : k => v if v.azure_ad_user_type == "Member" }

  user_principal_name = each.value.user_principal_name
  display_name        = each.value.display_name
  mail_nickname       = each.value.mail_nickname
  password            = random_password.user_passwords[each.key].result
  usage_location      = "US"
}

resource "azuread_invitation" "guest_user" {
  for_each           = { for k, v in var.users : k => v if v.azure_ad_user_type == "Guest" }
  user_display_name  = each.value.display_name
  user_email_address = each.value.user_principal_name
  redirect_url       = "https://portal.azure.com"

  message {
    body = "Hello there! You are invited to join my Azure tenant!"
  }
}

resource "azuread_app_role_assignment" "assignments_member" {
  for_each = { for k, v in var.users : k => v if v.azure_ad_user_type == "Member" }

  app_role_id         = local.role_mapping[each.value.role]
  resource_object_id  = azuread_service_principal.sso_sp.object_id
  principal_object_id = azuread_user.user[each.key].object_id
}

resource "azuread_app_role_assignment" "assignments_guest" {
  for_each = { for k, v in var.users : k => v if v.azure_ad_user_type == "Guest" }

  app_role_id         = local.role_mapping[each.value.role]
  resource_object_id  = azuread_service_principal.sso_sp.object_id
  principal_object_id = azuread_invitation.guest_user[each.key].user_id
}
