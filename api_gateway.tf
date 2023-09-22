resource "aws_api_gateway_rest_api" "image_upload_api" {
  name        = "ImageUploadAPI"
  description = "API for image uploads"
}

resource "aws_api_gateway_resource" "image_resource" {
  rest_api_id = aws_api_gateway_rest_api.image_upload_api.id
  parent_id   = aws_api_gateway_rest_api.image_upload_api.root_resource_id
  path_part   = "image"
}

resource "aws_api_gateway_method" "post_image" {
  rest_api_id   = aws_api_gateway_rest_api.image_upload_api.id
  resource_id   = aws_api_gateway_resource.image_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.image_upload_api.id
  resource_id = aws_api_gateway_resource.image_resource.id
  http_method = aws_api_gateway_method.post_image.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.image_upload_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "image_api_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]

  rest_api_id = aws_api_gateway_rest_api.image_upload_api.id
  stage_name  = "prod"
}