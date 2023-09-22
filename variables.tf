variable "region" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "S3_BUCKET" {
  description = "The name of the S3 bucket"
  default     = "s3-image-processing-8a73"  #
}