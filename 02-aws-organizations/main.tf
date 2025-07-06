module "organization" {
  source                = "./modules/aws-organization"
  organization_accounts = local.organization_accounts
  organizational_units  = local.organizational_units
}
