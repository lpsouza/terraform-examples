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

variable "EC2_INSTANCE_TYPE" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

}

variable "EC2_AMI" {
  description = "EC2 AMI"
  type        = string
  default     = "ami-0c7217cdde317cfec" # Ubuntu 22.04
}

variable "EC2_VM_NAME" {
  description = "EC2 VM name"
  type        = string
  default     = "my-vm"
}
