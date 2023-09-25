output "image_upload_lambda_arn" {
  description = "The ARN of the imageUploadFunction Lambda function"
  value       = aws_lambda_function.image_upload_lambda.arn
}

output "image_upload_lambda" {
  description = "The imageUploadFunction Lambda function"
  value       = aws_lambda_function.image_upload_lambda.function_name
}

output "image_upload_lambda_invoke_arn" {
  description = "The Invoke-ARN of the imageUploadFunction Lambda function"
  value       = aws_lambda_function.image_upload_lambda.invoke_arn
}

output "image_processing_lambda_arn" {
  description = "The ARN of the imageProcessingFunction Lambda function"
  value       = aws_lambda_function.image_processing_lambda.arn
}
