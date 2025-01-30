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

variable "SERVICE_ACCOUNT_EMAIL" {
  description = "The email of the service account"
  type        = string
  default     = "service-account@my-gcp-project-example.iam.gserviceaccount.com"
}

variable "CLUSTER_NAME" {
  description = "The name of the Dataproc cluster"
  type        = string
  default     = "my-dataproc-cluster"
}
