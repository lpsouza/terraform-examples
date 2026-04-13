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
  description = "AWS key pair"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAA... user@host"
}

variable "CLUSTER_NAME" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "EKS_VERSION" {
  description = "EKS version"
  type        = string
  default     = "1.32"
}

variable "INSTANCE_TYPE" {
  description = "EC2 instance type for the EKS nodes"
  type        = string
  default     = "m6g.large"
}

variable "EKS_MIN_NODES" {
  description = "Minimum number of nodes in the EKS cluster"
  type        = number
  default     = 1
}

variable "EKS_MAX_NODES" {
  description = "Maximum number of nodes in the EKS cluster"
  type        = number
  default     = 1
}

variable "EKS_DESIRED_NODES" {
  description = "Desired number of nodes in the EKS cluster"
  type        = number
  default     = 1
}
