module "datadog_logging" {
  source = "./modules/datadog-logging"
  providers = {
    aws = aws.logging
  }
  datadog_api_key        = var.datadog_api_key
  cloudtrail_kms_key_arn = data.aws_kms_key.by_alias.arn
}
