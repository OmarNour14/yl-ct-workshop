locals {
  aft_account_secrets   = jsondecode(data.aws_secretsmanager_secret_version.aft_account_secrets_versions.secret_string)
  aws_ct_mgt_account_id = local.aft_account_secrets["aws_ct_mgt_account_id"]
  aws_ct_mgt_org_id     = local.aft_account_secrets["aws_ct_mgt_org_id"]
}
