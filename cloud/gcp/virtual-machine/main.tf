provider "google" {
  credentials = file("credentials.json")
  project     = "your-gcp-project-id"
  region      = "us-central1"
}

resource "google_compute_network" "my_network" {
  name                    = "my-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my_subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.my_network.name
  region        = "us-central1"
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

resource "google_compute_instance" "free_instance" {
  name         = "free-vm-instance"
  machine_type = "f1-micro"  # Part of GCP's free tier

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"  # Latest Ubuntu 22.04 LTS image
    }
  }

  network_interface {
    network = google_compute_network.my_network.name
    subnetwork = google_compute_subnetwork.my_subnet.name

    access_config {}
  }

  metadata = {
    ssh-keys = "your-ssh-key"  # Replace with your SSH public key
  }
}
