variable "delegated_security_services" {
  description = "values for security foundation principles"
  type        = list(string)
  default = [
    "access-analyzer.amazonaws.com",
    "securityhub.amazonaws.com",
    "guardduty.amazonaws.com",
    "malware-protection.guardduty.amazonaws.com",
    "auditmanager.amazonaws.com"
  ]
}

variable "enable_security_account_delegated_admin" {
  description = "Flag to enable delegated administration for the security account"
  type        = bool
  default     = true
}

variable "aws_security_account_id" {
  description = "AWS Account ID for the security account"
  type        = string
  default     = "" # replace with actual security account ID
}
