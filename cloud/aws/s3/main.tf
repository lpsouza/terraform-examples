provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

resource "aws_s3_bucket" "my_bucket" {
  bucket        = var.S3_BUCKET_NAME
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "my_bucket_lifecycle" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    id     = "MoveToInfrequentAccess"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  rule {
    id     = "MoveToGlacier"
    status = "Enabled"

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}
