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

provider "helm" {
  version         = "~> 0.10"
  install_tiller  = true
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.13.1"
  service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
  namespace       = "${kubernetes_service_account.tiller.metadata.0.namespace}"

  kubernetes {
    host                   = "https://${module.cluster.endpoint}"
    token                  = "${data.google_client_config.default.access_token}"
    cluster_ca_certificate = "${base64decode(module.cluster.ca_certificate)}"
  }
}
