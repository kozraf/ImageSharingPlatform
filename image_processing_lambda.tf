resource "aws_lambda_function" "image_processing_lambda" {
  function_name    = "imageProcessingFunction"
  handler          = "image_processing_lambda.lambda_handler"  # updated
  runtime          = "python3.9"  # updated
  role             = aws_iam_role.lambda_exec.arn
  filename         = "image_processing_lambda.zip"

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.s3-image-processing.bucket
    }
  }
}

resource "aws_lambda_permission" "allow_s3_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processing_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.s3-image-processing.arn
}

