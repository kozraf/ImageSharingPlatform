resource "aws_lambda_function" "image_upload_lambda" {
  function_name = "imageUploadFunction"
  handler       = "index.handler"  // This should match with your code file and export
  role          = var.iam_role_arn
  filename      = "./modules/lambdas/payloads/image_upload_lambda.zip"  // ZIP file containing your Lambda function code
  runtime       = "nodejs14.x"

  environment {
    variables = {
      S3_BUCKET = var.s3_bucket_name
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_upload_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_upload_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # Depending on how specific you want to be, you can also limit the source ARN
  # source_arn = "${aws_api_gateway_deployment.image_api_deployment.execution_arn}/*/*"
}

resource "aws_lambda_function" "image_processing_lambda" {
  function_name    = "imageProcessingFunction"
  handler          = "image_processing_lambda.lambda_handler"  # updated
  runtime          = "python3.9"  # updated
  role             = var.iam_role_arn
  filename         = "./modules/lambdas/payloads/image_processing_lambda.zip"

  environment {
    variables = {
      S3_BUCKET = var.s3_bucket_name
    }
  }
}

resource "aws_lambda_permission" "allow_s3_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processing_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}