resource "aws_s3_bucket" "s3-image-processing" {
  bucket = "s3-image-processing"


  # S3 Event to trigger Lambda function for image processing
  bucket_notification {
    lambda_function {
      lambda_function_arn = aws_lambda_function.image_processing_lambda.arn
      events              = ["s3:ObjectCreated:*"]
    }
  }
}

# Assume that the Lambda function for image processing is defined as follows:
resource "aws_lambda_function" "image_processing_lambda" {
  # Lambda function configuration here
}