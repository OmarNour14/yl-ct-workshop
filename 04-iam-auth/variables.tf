variable "enable_teleport" {
  type        = bool
  description = "variable to enable the teleport integration"
  default     = true
}

variable "user_first_name" {
  type        = string
  description = "The name of the user running the workshop, used to create unique resources"
}

variable "user_last_name" {
  type        = string
  description = "The last name of the user running the workshop, used to create unique resources"
}

variable "user_email" {
  type        = string
  description = "The email of the user running the workshop, used to create unique resources"
}


variable "teleport_saml" {
  type        = string
  description = "SAML entity ID and Assertion Consumer Service URL for the Teleport SSO instance"
  sensitive   = true
}
