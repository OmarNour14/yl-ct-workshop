#################################################################
# Validate Organization Root Features
#################################################################

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "my_bucket" {
  count  = var.validate_org_root_features ? 1 : 0
  bucket = "validate-org-root-features-bucket-${random_id.suffix.hex}"
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  count  = var.validate_org_root_features ? 1 : 0
  bucket = aws_s3_bucket.my_bucket[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "ExplicitDenyAll"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.my_bucket[0].bucket}",
          "arn:aws:s3:::${aws_s3_bucket.my_bucket[0].bucket}/*"
        ]
      }
    ]
  })
  depends_on = [aws_s3_bucket.my_bucket]
}
