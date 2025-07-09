module "organization" {
  source                                  = "./modules/aws-organization"
  enable_security_account_delegated_admin = true
  aws_security_account_id                 = var.security_account_id
}



module "security_foundation_management" {
  source                     = "./modules/security-foundation-management"
  validate_org_root_features = false
  aws_security_account_id    = var.security_account_id
  depends_on                 = [module.organization]
}

module "security_foundation_security" {
  source = "./modules/security-foundation-security"
  providers = {
    aws = aws.security
  }
  validate_iam_access_analyzer             = false
  enable_member_account_invites            = false
  enable_sechub_aggregator                 = false
  enable_sechub_insights                   = false
  enable_sechub_automation_rule            = false
  enable_sechub_ecr_remediation            = false
  enable_sechub_slack_integration          = false
  security_hub_member_invite               = local.security_hub_member_invite
  securityhub_aggregator_specified_regions = var.securityhub_aggregator_specified_regions
  aws_management_account_id                = data.aws_caller_identity.current.account_id
  aws_production_account_id                = var.production_account_id
  slack_channel_id                         = var.slack_channel_id
  slack_team_id                            = var.slack_team_id
  depends_on                               = [module.organization, module.security_foundation_management]
}
