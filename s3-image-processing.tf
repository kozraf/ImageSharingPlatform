# S3 Bucket for Image Processing and Web Hosting
resource "aws_s3_bucket" "s3-image-processing" {
  #bucket = "s3-image-processing-P42u"
  bucket = var.S3_BUCKET

# depends_on = [aws_api_gateway_deployment.image_api_deployment]
}

resource "aws_s3_bucket_public_access_block" "s3_access_block" {
  bucket = aws_s3_bucket.s3-image-processing.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 10"  # Introduce a delay of 30 seconds using bash
  }

  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [aws_s3_bucket_public_access_block.s3_access_block]
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
        "Action": ["s3:GetObject", "s3:PutObject"],
        "Resource": "${aws_s3_bucket.s3-image-processing.arn}/*"
      }
    ]
  })

  depends_on = [null_resource.delay]
}

# S3 Website Configuration
resource "aws_s3_bucket_website_configuration" "s3_website_configuration" {
  bucket = aws_s3_bucket.s3-image-processing.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "website_index" {
  bucket = aws_s3_bucket.s3-image-processing.bucket
  key    = "index.html"
  source = "index.html"  # Path to your index.html file on your local machine
  content_type = "text/html"
  #etag   = filemd5("index.html")

  lifecycle {
    ignore_changes = [etag]
  }

}


