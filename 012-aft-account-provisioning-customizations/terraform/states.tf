resource "aws_sfn_state_machine" "aft_account_provisioning_customizations" {
  name     = "aft-account-provisioning-customizations"
  role_arn = aws_iam_role.aft_states.arn
  definition = templatefile("${path.module}/states/customizations.asl.json", {
    data_aft_alternate_contacts_state = module.alternate-contacts.aft_alternate_contacts_state_machine_arn
  })
  depends_on = [
    aws_iam_role_policy.aft_states
  ]
}
