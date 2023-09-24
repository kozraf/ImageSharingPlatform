provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "lambdas" {
  source         = "./modules/lambdas"

  s3_bucket_name = aws_s3_bucket.s3-image-processing.bucket
  s3_bucket_arn  = aws_s3_bucket.s3-image-processing.arn
  iam_role_arn   = aws_iam_role.lambda_exec.arn

}