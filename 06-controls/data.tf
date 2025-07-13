data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_unit" "ou" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
  name      = var.platform_ou_name
}
