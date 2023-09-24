resource "aws_api_gateway_account" "example" {
  cloudwatch_role_arn = aws_iam_role.lambda_exec.arn
}

resource "aws_api_gateway_rest_api" "image_upload_api" {
  name        = "ImageUploadAPI"
  description = "API for uploading images to S3"
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
  uri                     = module.lambdas.image_upload_lambda_invoke_arn
# uri                     = aws_lambda_function.image_upload_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "image_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.image_upload_api.id
  stage_name  = "prod"

#  provisioner "local-exec" {
#    command = "update_html.bat ${aws_api_gateway_deployment.image_api_deployment.invoke_url}"
#  }

  # This ensures that the local-exec provisioner runs every time this resource is created or changed
#  triggers = {
#    always_run = "${timestamp()}"
#  }

}


# CORS configuration

resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.image_upload_api.id
  resource_id   = aws_api_gateway_resource.image_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.image_upload_api.id
  resource_id = aws_api_gateway_resource.image_resource.id
  http_method = aws_api_gateway_method.options.http_method

  type                    = "MOCK"
  integration_http_method = "OPTIONS"
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.image_upload_api.id
  resource_id = aws_api_gateway_resource.image_resource.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.image_upload_api.id
  resource_id = aws_api_gateway_resource.image_resource.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_integration.options_integration]
}

resource "aws_api_gateway_method_response" "post_200" {
  rest_api_id = aws_api_gateway_rest_api.image_upload_api.id
  resource_id = aws_api_gateway_resource.image_resource.id
  http_method = aws_api_gateway_method.post_image.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "post" {
  rest_api_id = aws_api_gateway_rest_api.image_upload_api.id
  resource_id = aws_api_gateway_resource.image_resource.id
  http_method = aws_api_gateway_method.post_image.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [aws_api_gateway_integration.lambda_integration]
}

# Outputs

output "api_gateway_url" {
  value = aws_api_gateway_deployment.image_api_deployment.invoke_url
  description = "The URL of the deployed API Gateway"
}