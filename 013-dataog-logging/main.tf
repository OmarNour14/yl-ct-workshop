module "datadog_logging" {
  source = "./modules/datadog-logging"
  providers = {
    aws = aws.logging
  }
  datadog_api_key                    = var.datadog_api_key
  mgt_account_cloudtrail_bucket_name = module.get_cloudtrail_bucket.result[0]
  mgt_account_cloudtrail_kms_key_arn = data.aws_kms_key.by_alias.arn
}
