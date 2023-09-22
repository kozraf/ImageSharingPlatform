# S3 Bucket for Image Processing and Web Hosting
resource "aws_s3_bucket" "s3-image-processing" {
  bucket = "s3-image-processing"
}

resource "aws_s3_bucket_public_access_block" "s3_access_block" {
  bucket = aws_s3_bucket.s3-image-processing.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3-image-processing.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PublicReadGetObject",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.s3-image-processing.arn}/*"
      }
    ]
  })
}



# S3 Website Configuration
resource "aws_s3_bucket_website_configuration" "s3_website_configuration" {
  bucket = aws_s3_bucket.s3-image-processing.id

  index_document {
    suffix = "index.html"
  }
}


# S3 Event to trigger Lambda function for image processing
 resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.s3-image-processing.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_upload_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
