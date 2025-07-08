locals {
  role_mapping = {
    for k in keys(var.azure_app_roles) :
    k => uuidv5("url", "urn:${k}")
  }
}
