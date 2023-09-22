resource "aws_lambda_function" "image_upload_lambda" {
  function_name = "imageUploadFunction"
  handler       = "index.handler"  // This should match with your code file and export
  role          = aws_iam_role.lambda_exec.arn
  filename      = "image_upload_payload.zip"  // ZIP file containing your Lambda function code
  runtime       = "nodejs14.x"

  environment {
    variables = {
      S3_BUCKET = "s3-image-processing"
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_upload_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.s3-image-processing.arn
}