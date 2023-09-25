provider "aws" {
  region     = var.region
}

terraform {
  backend "s3" {
    bucket         = "tf-state-s3-for-imagesharingprogram2"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate_lock"
    encrypt        = true
  }
}

module "lambdas" {
  source         = "./modules/lambdas"

  s3_bucket_name = aws_s3_bucket.s3-image-processing.bucket
  s3_bucket_arn  = aws_s3_bucket.s3-image-processing.arn
  iam_role_arn   = aws_iam_role.lambda_exec.arn

}