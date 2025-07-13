module "get_cloudtrail_bucket" {
  source           = "digitickets/cli/aws"
  version          = "6.1.0"
  aws_cli_commands = ["s3api", "list-buckets"]
  aws_cli_query    = "Buckets[?starts_with(Name, `${var.cloudtrail_bucket_name}`)].Name"
}
