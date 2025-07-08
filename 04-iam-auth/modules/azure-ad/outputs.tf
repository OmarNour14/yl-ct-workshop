output "client_id" {
  value = azuread_application.sso.client_id
}

output "app_role_ids" {
  value = local.role_mapping
}

output "user_credentials" {
  description = "Login credentials for Member users"
  sensitive   = true
  value = {
    for user_key in keys(azuread_user.user) : user_key => {
      username = azuread_user.user[user_key].user_principal_name
      password = random_password.user_passwords[user_key].result
    }
  }
}
