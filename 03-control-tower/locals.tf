locals {
  organizational_units = {
    "Product" = {
      name = var.product_ou_name
    }

  }

  organization_accounts = {
    security = {
      name  = var.security_account_name
      email = var.security_account_email
    }
    logging = {
      name  = var.logging_account_name
      email = var.logging_account_email
    }
  }

  aws_access_portal_url = "https://${data.aws_ssoadmin_instances.management_account.identity_store_ids[0]}.awsapps.com/start"

}
