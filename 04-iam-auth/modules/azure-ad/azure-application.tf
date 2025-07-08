resource "azuread_application" "sso" {
  display_name     = var.prefix
  owners           = [data.azuread_client_config.current.object_id]
  logo_image       = var.logo_image_base64
  sign_in_audience = "AzureADMyOrg"
  feature_tags {
    custom_single_sign_on = true
    enterprise            = true

  }

  web {
    redirect_uris = [var.saml_acs]
  }
  group_membership_claims = ["SecurityGroup"]

  dynamic "app_role" {
    for_each = var.azure_app_roles

    content {
      id                   = uuidv5("url", "urn:${app_role.key}")
      value                = app_role.key
      description          = app_role.value
      display_name         = app_role.value
      allowed_member_types = ["User"]
    }
  }
  lifecycle {
    ignore_changes = [
      identifier_uris,
    ]
  }
}

resource "azuread_service_principal" "sso_sp" {
  client_id                    = azuread_application.sso.client_id
  app_role_assignment_required = true
  owners                       = [data.azuread_client_config.current.object_id]
  login_url                    = var.login_url != "" ? var.login_url : null
  feature_tags {
    custom_single_sign_on = true
    enterprise            = true
  }
  preferred_single_sign_on_mode = "saml"
}

resource "azuread_application_identifier_uri" "identifier_uri" {
  application_id = azuread_application.sso.id
  identifier_uri = var.saml_entity_id
  depends_on     = [azuread_service_principal.sso_sp]
}

#################################################
# SAML Metadata Generation for SSO Application
#################################################

resource "time_rotating" "saml-certificate" {
  rotation_years = 3
}

resource "azuread_service_principal_token_signing_certificate" "saml-certificate" {
  service_principal_id = azuread_service_principal.sso_sp.id
  display_name         = "CN=${var.prefix} SSO Certificate"
  end_date             = time_rotating.saml-certificate.rotation_rfc3339

  provisioner "local-exec" {
    # NB this is in a single line to make it work in a linux or windows host.
    command = "az ad sp update --id ${azuread_service_principal.sso_sp.object_id} --set preferredTokenSigningKeyThumbprint=${self.thumbprint}"
  }
}
