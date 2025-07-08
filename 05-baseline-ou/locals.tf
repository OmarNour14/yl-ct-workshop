locals {
  organizational_units = {
    "Platform" = {
      name = var.platform_ou_name
    }
  }


  organization_accounts = {
    platform = {
      name  = var.platform_account_name
      email = var.platform_account_email
      ou    = local.organizational_units.Platform.name
    }

  }

}
