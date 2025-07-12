resource "aws_controltower_control" "control" {
  for_each           = local.controls
  control_identifier = "arn:aws:controlcatalog:::control/${each.value.control_identifier}"
  target_identifier  = each.value.target_identifier
}


############################################################################
# Control Tower Landing Zone Controls Validation
# UnComment out this module block if you are using a platform profile
# and want to validate the Control Tower Landing Zone Controls
############################################################################


# module "control_tower_controls_validation" {
#   providers = {
#     aws = aws.platform
#   }
#   source = "./modules/controls-validation"
# }
