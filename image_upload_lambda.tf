resource "aws_lambda_function" "image_upload_lambda" {
  function_name = "imageUploadFunction"
  handler       = "index.handler"  // This should match with your code file and export
  role          = aws_iam_role.lambda_exec.arn
  filename      = "image_upload_lambda.zip"  // ZIP file containing your Lambda function code
  runtime       = "nodejs14.x"

  environment {
    variables = {
      S3_BUCKET = var.S3_BUCKET
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

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_upload_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # Depending on how specific you want to be, you can also limit the source ARN
  # source_arn = "${aws_api_gateway_deployment.image_api_deployment.execution_arn}/*/*"
}
