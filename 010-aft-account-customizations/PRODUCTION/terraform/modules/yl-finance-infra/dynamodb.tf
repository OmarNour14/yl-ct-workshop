resource "aws_dynamodb_table" "loan_table" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "loanID"
  attribute {
    name = "loanID"
    type = "S"
  }
}
