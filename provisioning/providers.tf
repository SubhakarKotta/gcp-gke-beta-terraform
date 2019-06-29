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
