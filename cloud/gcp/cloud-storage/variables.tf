variable "PROJECT_ID" {
  description = "The GCP project ID"
  type        = string
  default     = "my-gcp-project-example"
}

variable "REGION" {
  description = "The GCP region"
  type        = string
  default     = "us-west1"
}

variable "BUCKET_NAME" {
  description = "The name of the GCS bucket"
  type        = string
  default     = "my-storage-bucket"
}

variable "SERVICE_ACCOUNT_EMAIL" {
  description = "The email of the service account"
  type        = string
  default     = "service-account@my-gcp-project-example.iam.gserviceaccount.com"
}
