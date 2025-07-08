resource "azuread_claims_mapping_policy" "teleport_policy" {
  count = var.application_type == "teleport" ? 1 : 0

  display_name = "teleport-claims-policy"
  definition = [jsonencode({
    "ClaimsMappingPolicy" : {
      "Version" : 1,
      "IncludeBasicClaimSet" : true,
      "ClaimsSchema" : [
        {
          "Source" : "user",
          "ID" : "userprincipalname",
          "JwtClaimType" : "nameidentifier"
        },
        {
          "Source" : "user",
          "ID" : "userprincipalname",
          "JwtClaimType" : "upn"
        },
        {
          "Source" : "user",
          "ID" : "email",
          "JwtClaimType" : "email"
        },
        {
          "Source" : "user",
          "ID" : "groups",
          "JwtClaimType" : "groups"
        }
      ]
    }
  })]
}


resource "azuread_service_principal_claims_mapping_policy_assignment" "teleport_assignment" {
  count                    = var.application_type == "teleport" ? 1 : 0
  claims_mapping_policy_id = azuread_claims_mapping_policy.teleport_policy[0].id
  service_principal_id     = azuread_service_principal.sso_sp.id
}
