variable "s3_bucket_name" {
  description = "The name of the S3 bucket used for image uploads"
  type        = string
}
variable "iam_role_arn" {
  description = "The ARN of the IAM role for the Lambda function"
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket used for image uploads"
  type        = string
}