provider "google" {
  project = var.PROJECT_ID
  region  = var.REGION
}

resource "google_compute_network" "my_network" {
  name                    = "my-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my_subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.my_network.name
  region        = var.REGION
}

resource "google_compute_firewall" "allow-internal" {
  name    = "${google_compute_network.my_network.name}-allow-internal"
  network = google_compute_network.my_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/8"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.my_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_project_iam_member" "dataproc_worker_binding" {
  project = var.PROJECT_ID
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${var.SERVICE_ACCOUNT_EMAIL}"
}

resource "google_project_iam_member" "dataproc_editor_binding" {
  project = var.PROJECT_ID
  role    = "roles/dataproc.editor"
  member  = "serviceAccount:${var.SERVICE_ACCOUNT_EMAIL}"
}

resource "google_dataproc_cluster" "my_cluster" {
  name   = var.CLUSTER_NAME
  region = var.REGION

  cluster_config {
    gce_cluster_config {
      subnetwork      = google_compute_subnetwork.my_subnet.name
      service_account = var.SERVICE_ACCOUNT_EMAIL
    }
    master_config {
      num_instances = 1
      machine_type  = "n1-standard-2"
    }

    worker_config {
      num_instances = 2
      machine_type  = "n1-standard-2"
    }
  }

  depends_on = [
    google_project_iam_member.dataproc_worker_binding,
    google_project_iam_member.dataproc_editor_binding
  ]
}
