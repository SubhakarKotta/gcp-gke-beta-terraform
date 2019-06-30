provider "google" {
  version = "~> 2.9"
  project = "${var.project_id}"
  region  = "${var.region}"
}

provider "google-beta" {
  version = "~> 2.9"
  project = "${var.project_id}"
  region  = "${var.region}"
}

provider "kubernetes" {
  version                = "~> 1.7"
  host                   = "https://${module.cluster.endpoint}"
  token                  = "${data.google_client_config.default.access_token}"
  cluster_ca_certificate = "${base64decode(module.cluster.ca_certificate)}"
}
