variable "security_account_id" {
  description = "AWS Account ID for the security account"
  type        = string
}

variable "management_account_email" {
  description = "Email address for the management account"
  type        = string
  default     = "" # replace with actual management account email
}

variable "logging_account_id" {
  description = "AWS Account ID for the logging account"
  type        = string
  default     = "" # replace with actual logging account ID
}


variable "logging_account_email" {
  description = "Email address for the logging account"
  type        = string
}

variable "platform_account_id" {
  description = "AWS Account ID for the platform account"
  type        = string
  default     = "" # replace with actual platform account ID
}

variable "platform_account_email" {
  description = "Email address for the platform account"
  type        = string
}


variable "securityhub_aggregator_specified_regions" {
  description = "List of regions to enable Security Hub finding aggregator"
  type        = list(string)
  default     = ["eu-west-2", "eu-west-3"]
}

variable "slack_channel_id" {
  description = "Slack channel ID for the chatbot integration"
  type        = string
  default     = "" # replace with actual Slack channel ID
}

variable "slack_team_id" {
  description = "Slack team ID for the chatbot integration"
  type        = string
  default     = "" # replace with actual Slack team ID
}
