resource "google_container_cluster" "primary" {
  provider = google
  name = "my-gke-cluster"
  location = "us-central1"
  initial_node_count = 1
  // GCP Kubernetes Engine Clusters have Legacy Authorization enabled
  // $.resource[*].google_container_cluster.*.*[*].enable_legacy_abac anyTrue

  tags = {
    Name = "google_container_cluster"
  }
  network_policy {
    enabled = true
  }
  pod_security_policy_config {
    enabled = true
  }
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  enable_binary_authorization = true
  min_master_version = "1.12"
  enable_intranode_visibility = true
}

resource "google_storage_bucket" "static-site" {
  name = "image-store.com"
  location = "EU"
  force_destroy = true
  versioning {
    enabled = false
  }
  tags = {
    Name = "google_storage_bucket"
  }
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.static-site.name
  role = "READER"
  entity = "allUsers"
  tags = {
    Name = "google_storage_bucket_access_control"
  }
}
