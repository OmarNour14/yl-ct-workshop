resource "aws_apigatewayv2_api" "loan_api" {
  name          = "LoanAPI"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.loan_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.loan_handler.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "loan_route" {
  api_id    = aws_apigatewayv2_api.loan_api.id
  route_key = "ANY /loans/{proxy+}" # Handles GET, POST, DELETE, OPTIONS, etc.
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.loan_api.id
  name        = "$default"
  auto_deploy = true
}
