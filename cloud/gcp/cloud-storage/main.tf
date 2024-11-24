provider "google" {
  project = var.PROJECT_ID
  region  = var.REGION
}

resource "random_id" "bucket_id" {
  byte_length = 8
}

resource "google_storage_bucket" "my_bucket" {
  name          = "${var.BUCKET_NAME}-${random_id.bucket_id.hex}"
  location      = var.REGION
  storage_class = "STANDARD"
  force_destroy = true

  lifecycle_rule {
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition {
      age = 30
    }
  }
}

resource "google_storage_bucket_iam_member" "my_bucket_iam" {
  bucket = google_storage_bucket.my_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${var.SERVICE_ACCOUNT_EMAIL}"
}
