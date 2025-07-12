locals {
  controls = {
    detective_controls_dynamodb = {
      alias              = "SH.DynamoDB.1"
      control_identifier = "keijcuz1a7n70grfn62tb2jj"
      target_identifier  = data.aws_organizations_organizational_unit.ou.arn
    }
    proactive_controls_apigw = {
      alias              = "CT.APIGATEWAY.PR.4"
      control_identifier = "ro9dk09errhg8vo6flro4o7n"
      target_identifier  = data.aws_organizations_organizational_unit.ou.arn
    }
    preventive_controls_lambda = {
      alias              = "CT.LAMBDA.PV.2"
      control_identifier = "aksh80tizisat4i4ou8qg1hdy"
      target_identifier  = data.aws_organizations_organizational_unit.ou.arn
    }
  }

}
