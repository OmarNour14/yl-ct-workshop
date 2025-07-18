variable "external_account_id" {
  type    = string
  default = "111122223333" # replace with actual external account ID
}

variable "aws_platform_account_id" {
  description = "AWS Account ID for the platform account"
  type        = string
}

variable "aws_management_account_id" {
  description = "AWS Account ID for the management account"
  type        = string
}

variable "validate_org_root_features" {
  description = "Flag to enable org root feature validation"
  type        = bool
  default     = false
}

variable "validate_iam_access_analyzer" {
  description = "Flag to enable or disable IAM Access Analyzer validation"
  type        = bool
  default     = false
}

variable "use_eks_runtime_monitoring" {
  description = "Whether to use EKS_RUNTIME_MONITORING instead of RUNTIME_MONITORING"
  type        = bool
  default     = true
}

variable "enable_member_account_invites" {
  description = "Whether to enable inviting member accounts to Security Hub"
  type        = bool
  default     = false
}

variable "enable_sechub_insights" {
  description = "Flag to enable Security Hub insights"
  type        = bool
  default     = false
}

variable "enable_sechub_automation_rule" {
  description = "Flag to enable Security Hub automation rules"
  type        = bool
  default     = false
}

variable "enable_sechub_aggregator" {
  description = "Flag to enable Security Hub finding aggregator"
  type        = bool
  default     = false

}

variable "enable_sechub_ecr_remediation" {
  description = "Flag to enable Security Hub ECR remediation"
  type        = bool
  default     = false

}

variable "security_hub_member_invite" {
  description = "Map of Security Hub member accounts to invite"
  type = map(object({
    account_id = string
    email      = string
  }))
}

variable "securityhub_aggregator_specified_regions" {
  description = "List of regions to enable Security Hub finding aggregator"
  type        = list(string)
  default     = []
}

variable "enable_sechub_slack_integration" {
  description = "Flag to enable Security Hub Slack integration"
  type        = bool
  default     = false
}

variable "slack_channel_id" {
  description = "Slack channel ID for the chatbot integration"
  type        = string
  default     = ""
}

variable "slack_team_id" {
  description = "Slack team ID for the chatbot integration"
  type        = string
  default     = ""
}
