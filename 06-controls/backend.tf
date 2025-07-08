terraform {
  backend "s3" {
    bucket       = "{{REPLACE_WITH_S3_BUCKET}}"
    key          = "control-tower-controls/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}
