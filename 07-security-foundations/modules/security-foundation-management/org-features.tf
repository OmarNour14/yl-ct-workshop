resource "aws_iam_organizations_features" "root_features" {
  enabled_features = [
    "RootCredentialsManagement",
    "RootSessions"
  ]
}
