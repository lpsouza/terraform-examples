variable "AWS_REGION" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "AWS_ACCESS_KEY" {
  description = "AWS access key"
  type        = string
  default     = "ASDFASDFASDFASDFASDF"
}

variable "AWS_SECRET_KEY" {
  description = "AWS secret key"
  type        = string
  default     = "ASDFASDFASDFASDFASDFASDFASDFASDFASDFASDF"
}

variable "S3_BUCKET_NAME" {
  description = "S3 bucket name"
  type        = string
  default     = "my-bucket-example"
}
