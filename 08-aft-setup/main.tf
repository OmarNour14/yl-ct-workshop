module "aft_pipeline" {
  source = "git::https://github.com/aws-ia/terraform-aws-control_tower_account_factory.git?ref=1.14.1"
  # Required Variables
  ct_management_account_id    = data.aws_caller_identity.current.account_id
  log_archive_account_id      = var.logging_account_id
  audit_account_id            = var.security_account_id
  aft_management_account_id   = var.platform_account_id
  ct_home_region              = var.aws_region
  tf_backend_secondary_region = var.aws_secondary_region

  # Terraform variables
  terraform_version      = "1.6.0"
  terraform_distribution = "oss"

  # VCS Vars
  vcs_provider                                  = "github"
  account_request_repo_name                     = "${var.github_organization}/aft-account-request"
  global_customizations_repo_name               = "${var.github_organization}/aft-global-customizations"
  account_customizations_repo_name              = "${var.github_organization}/aft-account-customizations"
  account_provisioning_customizations_repo_name = "${var.github_organization}/aft-account-provisioning-customizations"

  # AFT Feature flags
  aft_feature_cloudtrail_data_events      = false
  aft_feature_enterprise_support          = false
  aft_feature_delete_default_vpcs_enabled = true

  # AFT Additional Configurations
  aft_enable_vpc                            = false
  backup_recovery_point_retention           = 1
  log_archive_bucket_object_expiration_days = 1
}

module "aft_deploy_prerequisite" {
  source     = "./modules/aft-deploy-prerequisite"
  depends_on = [module.aft_pipeline]
}
