variable "datadog_api_key" {
  description = "Datadog API key for the forwarder Lambda. Get this from your Datadog account."
  type        = string
  sensitive   = true
}


variable "cloudtrail_bucket_name" {
  description = "Name of the S3 bucket containing CloudTrail logs to be forwarded."
  type        = string
  default     = "aws-controltower-logs"

}
