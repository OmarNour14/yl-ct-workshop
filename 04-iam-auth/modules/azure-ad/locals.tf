locals {
  enterprise_app_name = "${var.user_first_name}-ct-${random_id.suffix.id}"
  role_mapping = {
    for k in keys(var.azure_app_roles) :
    k => uuidv5("url", "urn:${k}")
  }
}
