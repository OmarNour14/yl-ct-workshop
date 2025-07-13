output "dd_api_key" {
  value = aws_secretsmanager_secret.dd_api_key.arn
}
