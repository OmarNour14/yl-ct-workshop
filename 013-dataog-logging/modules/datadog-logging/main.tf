resource "aws_cloudformation_stack" "datadog_forwarder" {
  name         = "datadog-forwarder"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    DdApiKeySecretArn = aws_secretsmanager_secret.dd_api_key.arn
    DdSite            = var.datadog_site
    FunctionName      = var.forwarder_function_name
  }
  template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"
}

data "aws_iam_policy_document" "cloudtrail_logs" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.cloudtrail_bucket_name}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudformation_stack.datadog_forwarder.outputs["DatadogForwarderArn"]]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_logs" {
  bucket     = var.cloudtrail_bucket_name
  policy     = data.aws_iam_policy_document.cloudtrail_logs.json
  depends_on = [aws_cloudformation_stack.datadog_forwarder]
}


data "aws_iam_policy_document" "cloudtrail_kms" {
  statement {
    actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
    resources = [var.cloudtrail_kms_key_arn]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudformation_stack.datadog_forwarder.outputs["DatadogForwarderArn"]]
    }
  }
}

resource "aws_kms_key_policy" "cloudtrail" {
  key_id     = var.cloudtrail_kms_key_arn
  policy     = data.aws_iam_policy_document.cloudtrail_kms.json
  depends_on = [aws_cloudformation_stack.datadog_forwarder]
}

resource "aws_cloudwatch_log_subscription_filter" "forwarder" {
  name            = "datadog-forwarder"
  log_group_name  = var.cloudwatch_log_group_name
  filter_pattern  = ""
  destination_arn = aws_cloudformation_stack.datadog_forwarder.outputs["DatadogForwarderArn"]
  role_arn        = aws_cloudformation_stack.datadog_forwarder.outputs["DatadogForwarderRoleArn"]
}
