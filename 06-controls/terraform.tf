terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta3"
    }
  }
  required_version = ">= 0.13"
}


provider "aws" {
  region = "eu-west-1"
}

############################################################################
# UnComment out this provider block if you are using a production profile
# and want to validate the Control Tower Landing Zone Controls
############################################################################

# provider "aws" {
#   alias   = "production"
#   profile = "production"
#   region  = "eu-west-1"
# }
