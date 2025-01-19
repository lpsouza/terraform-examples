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

variable "AWS_KEY_PAIR" {
  description = "Public key for EC2 instances"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAA... user@host"
}

variable "CLUSTER_NAME" {
  description = "Name of the EMR cluster"
  type        = string
  default     = "my-emr-cluster"
}
