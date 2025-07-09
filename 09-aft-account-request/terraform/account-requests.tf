module "account_requests" {
  source   = "./modules/aft-account-request"
  for_each = local.accounts

  control_tower_parameters = {
    AccountEmail              = each.value.email
    AccountName               = each.value.name
    ManagedOrganizationalUnit = each.value.organization_unit
    SSOUserEmail              = each.value.sso_email
    SSOUserFirstName          = each.value.first_name
    SSOUserLastName           = each.value.last_name
  }

  account_tags = merge({
    "ABC:Owner" = each.value.email
  }, each.value.tags)

  change_management_parameters = {
    change_requested_by = "Terraform"
    change_reason       = "Automated multi-account provisioning"
  }

  custom_fields = merge(
    {
      another_custom_field1 = "a"
      another_custom_field2 = "b"
    },
    try(
      {
        alternate_contact = jsonencode(each.value.alternate_contact)
      },
      {}
    )
  )


  account_customizations_name = each.value.customizations_name
}
