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

#######################################################################################
# DONT FORGET TO ENABLE SECUIRTY ACCOUNT AS DELEGATED ADMIN IN THE ORGANIZATION MODULE
#######################################################################################

module "security_foundation_security" {
  source = "./modules/security-foundation-security"
  providers = {
    aws = aws.security
  }
  validate_iam_access_analyzer             = false
  security_hub_member_invite               = local.security_hub_member_invite
  securityhub_aggregator_specified_regions = var.securityhub_aggregator_specified_regions
  aws_management_account_id                = data.aws_caller_identity.current.account_id
  aws_production_account_id                = var.production_account_id
  enable_sechub_slack_integration          = false
  slack_channel_id                         = var.slack_channel_id
  slack_team_id                            = var.slack_team_id
  depends_on                               = [module.organization, module.security_foundation_management]
}
