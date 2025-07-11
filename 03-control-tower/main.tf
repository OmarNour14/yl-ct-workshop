module "organization" {
  source                = "./modules/aws-organization"
  organization_accounts = local.organization_accounts
  organizational_units  = local.organizational_units
}

module "iam_roles_ct" {
  source = "./modules/iam"
}

resource "null_resource" "wait_for_iam_roles" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [module.iam_roles_ct]
}

module "control_tower_landing_zone" {
  source              = "./modules/control-tower-landing-zone"
  governed_regions    = var.governed_regions
  security_account_id = module.organization.account_ids["security"]
  logging_account_id  = module.organization.account_ids["logging"]
  security_org_name   = var.security_ou_name
  depends_on = [
    module.organization,
    module.iam_roles_ct,
    null_resource.wait_for_iam_roles
  ]
}
