module "datadog_logging" {
  source = "./modules/datadog-logging"
  providers = {
    aws = aws.logging
  }
  datadog_api_key = var.datadog_api_key
  datadog_app_key = var.datadog_app_key
  organization_id = data.aws_organizations_organization.org.id
}
