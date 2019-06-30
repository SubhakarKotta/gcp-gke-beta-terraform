module "cluster" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "${var.project_id}"
  name                       = "${var.name}"
  region                     = "${var.region}"
  zones                      = "${var.zones}"
  network                    = "default"
  subnetwork                 = "default"
  ip_range_pods              = "${var.ip_range_pods}"
  ip_range_services          = "${var.ip_range_services}"
  http_load_balancing        = "${var.http_load_balancing}"
  node_pools                 = "${var.node_pools}"
  horizontal_pod_autoscaling = "${var.horizontal_pod_autoscaling}"
  kubernetes_dashboard       = "${var.kubernetes_dashboard}"
  network_policy             = "${var.network_policy}"
  node_pools_oauth_scopes    = "${var.node_pools_oauth_scopes}"
  node_pools_labels          = "${var.node_pools_labels}"
  node_pools_metadata        = "${var.node_pools_metadata}"
  node_pools_taints          = "${var.node_pools_taints}"
  node_pools_tags            = "${var.node_pools_tags}"
}

data "google_client_config" "default" {}

module "files" {
  version = "v0.6.0"
  source  = "matti/resource/shell"
  command = "gcloud container clusters get-credentials ${module.cluster.name} --region ${var.region} --project ${var.project_id}"
}

resource "local_file" "kubeconfig" {
  content  = "${module.files.stdout}"
  filename = "./kubeconfig_${module.cluster.name}"
}
