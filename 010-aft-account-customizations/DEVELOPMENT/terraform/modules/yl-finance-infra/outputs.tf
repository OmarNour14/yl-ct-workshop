output "api_gateway_url" {
  description = "The base URL of the deployed API Gateway"
  value       = aws_apigatewayv2_api.loan_api.api_endpoint
}

output "lambda_function_name" {
  description = "Deployed Lambda function name"
  value       = aws_lambda_function.loan_handler.function_name
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.loan_table.name
}
