variable "john_user_email" {
  type        = string
  description = "User principal name for John Doe"
}
variable "jane_user_email" {
  type        = string
  description = "User principal name for Jane Doe"
}

variable "enable_teleport" {
  type        = bool
  description = "variable to enable the teleport integration"
  default     = true
}

variable "teleport_app_prefix" {
  type        = string
  description = "Prefix for resources, used to avoid name collisions"
  default     = "control-tower-teleport"
}

variable "teleport_saml" {
  type        = string
  description = "SAML entity ID and Assertion Consumer Service URL for the Teleport SSO instance"
  sensitive   = true
}
