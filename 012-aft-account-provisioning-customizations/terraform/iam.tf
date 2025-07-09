resource "aws_iam_role" "aft_states" {
  name               = "aft-account-provisioning-customizations-role"
  assume_role_policy = templatefile("${path.module}/iam/trust-policies/states.tpl", { none = "none" })
}

resource "aws_iam_role_policy" "aft_states" {
  name = "aft-account-provisioning-customizations-policy"
  role = aws_iam_role.aft_states.id

  policy = templatefile("${path.module}/iam/role-policies/iam-aft-states.tpl", {
    data_aws_region                           = data.aws_region.aft_management_region.name
    data_aws_account_id                       = data.aws_caller_identity.aft_management_id.account_id
    alternate_contacts_customizations_sfn_arn = module.alternate-contacts.aft_alternate_contacts_state_machine_arn
  })
}
