data "aws_ssoadmin_instances" "management_account" {
  depends_on = [module.control_tower_landing_zone]
}
