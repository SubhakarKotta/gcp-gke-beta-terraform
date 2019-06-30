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

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

provider "kubernetes" {
  version          = "~> 1.7"
  load_config_file = true
  config_path      = "${local_file.kubeconfig.filename}"
}
