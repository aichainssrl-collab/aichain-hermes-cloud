# --- Terraform Configuration for a Standard VM on GCP ---

# 1. Provider Configuration
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# 2. Variable Definitions
variable "gcp_project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "gcp_region" {
  description = "The GCP region to deploy resources in."
  type        = string
  default     = "europe-west1"
}

variable "vm_zone" {
  description = "The zone for the VM."
  type        = string
  default     = "europe-west1-b"
}

variable "machine_type" {
  description = "The machine type for the VM."
  type        = string
  default     = "e2-standard-2" # 2 vCPU, 8 GB RAM
}

# 3. Network Resources
resource "google_compute_address" "vm_static_ip" {
  name   = "vm-static-ip"
  region = var.gcp_region
}

# 4. Main Compute Instance
resource "google_compute_instance" "main_vm" {
  name         = "main-vm-instance"
  machine_type = var.machine_type
  zone         = var.vm_zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 100
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = var.startup_script_path

  metadata = {
    enable-oslogin = "TRUE"
  }
}

variable "startup_script_path" {
  description = "Path to the startup script to be executed on first boot."
  type        = string
}

# 5. Output
output "vm_ip" {
  value = google_compute_instance.main_vm.network_interface[0].access_config[0].nat_ip
}
