# Outputs

output "api_gateway_url" {
  value = aws_api_gateway_deployment.image_api_deployment.invoke_url
  description = "The URL of the deployed API Gateway"
}

output "s3_bucket_website_url" {
  description = "Website URL of the S3 bucket"
  value       = "http://${aws_s3_bucket.s3-image-processing.bucket_regional_domain_name}"
}