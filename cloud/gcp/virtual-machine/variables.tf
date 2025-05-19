variable "PROJECT_ID" {
  description = "The GCP project ID"
  type        = string
  default     = "my-gcp-project"
}

variable "SSH_KEY" {
  description = "SSH key to use for the instances"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3... user@host"
}
