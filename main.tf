resource "google_compute_network" "vpc" {
name = "luc-vpc"
}

resource "google_compute_firewall" "firewall" {
  name    = "luc-firewall"
  network = "${google_compute_network.vpc.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "ip1" {
  name = "ip1"
}

resource "google_compute_instance" "vm-1" {
  name         = "vm-1"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "${google_compute_network.vpc.name}"
      access_config {
	nat_ip = "${google_compute_address.ip1.address}"
    }
  }
}

resource "google_compute_instance" "vm-2" {
  name         = "vm-2"
  machine_type = "g1-small"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  network_interface {
    network       = "${google_compute_network.vpc.name}"
}
}
