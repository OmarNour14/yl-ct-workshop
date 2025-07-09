variable "logging_account_id" {
  description = "AWS Account ID for the logging account"
  type        = string
}

variable "security_account_id" {
  description = "AWS Account ID for the security account"
  type        = string
}

variable "platform_account_id" {
  description = "AWS Account ID for the AFT account"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}


variable "aws_secondary_region" {
  description = "Secondary AWS region for cross-region replication"
  type        = string
  default     = "eu-west-2"
}

variable "github_organization" {
  description = "GitHub organization name for the repository"
  type        = string
}
