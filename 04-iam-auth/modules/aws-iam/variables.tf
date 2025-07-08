variable "identity_store_id" {
  type        = string
  description = "AWS Identity Store ID"
}

variable "sso_instance_arn" {
  type        = string
  description = "AWS SSO instance ARN"
}

variable "aws_account_id" {
  type        = string
  description = "Target AWS account ID for SSO role assignments"
}

variable "users" {
  description = "Map of users and their attributes"
  type = map(object({
    user_principal_name = string
    display_name        = string
    given_name          = string
    surname             = string
    email               = string
    role                = string
    mail_nickname       = optional(string, "")
    azure_ad_user_type  = optional(string, "Guest")
  }))
}

variable "roles" {
  description = "List of roles to create (used as group + permission set names)"
  type        = map(string)
}

variable "role_policies" {
  description = "Map of role name to AWS managed policy ARN"
  type        = map(string)
}
