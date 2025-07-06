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
}
