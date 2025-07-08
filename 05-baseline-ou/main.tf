module "organization" {
  source                = "./modules/aws-organization"
  organization_accounts = local.organization_accounts
  organizational_units  = local.organizational_units
}


module "baseline_ou" {
  source                 = "./modules/baseline-ou"
  organizational_unit_id = module.organization.ou_ids["Platform"]
  organization_id        = module.organization.organization_id
  depends_on             = [module.organization]
}
