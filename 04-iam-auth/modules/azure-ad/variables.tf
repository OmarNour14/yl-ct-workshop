variable "application_type" {
  type        = string
  description = "The type of the application we will deploy"
  default     = "aws"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources, used to avoid name collisions"
}

variable "saml_entity_id" {
  type        = string
  description = "AWS SAML entity ID for the IAM Identity Center SSO Application"
}

variable "saml_acs" {
  type        = string
  description = "AWS SAML Assertion Consumer Service (ACS) URL"
}
variable "login_url" {
  type        = string
  description = "The Login URL"
  default     = ""
}

variable "azure_app_roles" {
  description = "Map of Azure AD App roles"
  type        = map(string)
}

variable "logo_image_base64" {
  description = "Base64-encoded logo image for the Azure AD application"
  type        = string
}


variable "users" {
  description = "Map of user objects"
  type = map(object({
    user_principal_name = string
    display_name        = string
    mail_nickname       = string
    role                = string
    azure_ad_user_type  = string
    given_name          = optional(string, "")
    surname             = optional(string, "")
    email               = optional(string, "")
  }))
}
