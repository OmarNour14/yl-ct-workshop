data "aws_caller_identity" "current" {}

data "aws_ssoadmin_instances" "management_account" {}

data "aws_iam_policy" "AdministratorAccess" {
  name = "AdministratorAccess"
}

data "aws_iam_policy" "ReadOnlyAccess" {
  name = "ReadOnlyAccess"
}
