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
  version          = "~> 1.7"
  load_config_file = true
  config_path      = "${local_file.kubeconfig.filename}"
}
