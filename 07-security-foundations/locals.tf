locals {
  security_hub_member_invite = {
    management = {
      account_id = data.aws_caller_identity.current.account_id
      email      = var.management_account_email
    }
    logging = {
      account_id = var.logging_account_id
      email      = var.logging_account_email
    }
    production = {
      account_id = var.production_account_id
      email      = var.production_account_email
    }
  }

}
