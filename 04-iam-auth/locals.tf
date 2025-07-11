locals {
  suffix = random_pet.user_suffix.id
  identity_users = {
    admin = {
      user_principal_name = var.user_email
      display_name        = "${var.user_first_name}" + " " + "${var.user_last_name}"
      given_name          = var.user_first_name
      surname             = var.user_last_name
      email               = var.user_email
      mail_nickname       = var.user_first_name
      role                = "admin"
      azure_ad_user_type  = "Guest"
    },
    jane = {
      user_principal_name = "jane.smith.${local.suffix}@youlend.com"
      display_name        = "Jane Smith ${local.suffix}"
      given_name          = "Jane"
      surname             = "Smith"
      email               = "jane.smith.${local.suffix}@youlend.com"
      mail_nickname       = "jane.smith.${local.suffix}"
      role                = "platform"
      azure_ad_user_type  = "Guest"
    },
    john = {
      user_principal_name = "john.doe.${local.suffix}@youlend.com"
      display_name        = "John Doe ${local.suffix}"
      given_name          = "John"
      surname             = "Doe"
      email               = "john.doe.${local.suffix}@youlend.com"
      mail_nickname       = "john.doe.${local.suffix}"
      role                = "product"
      azure_ad_user_type  = "Guest"
    }
  }
  identity_users_roles = {
    platform = "Platform"
    product  = "Product"
    admin    = "Admin"
  }
  identity_users_role_policies = {
    platform = data.aws_iam_policy.AdministratorAccess.arn
    product  = data.aws_iam_policy.ReadOnlyAccess.arn
    admin    = data.aws_iam_policy.AdministratorAccess.arn
  }


}
