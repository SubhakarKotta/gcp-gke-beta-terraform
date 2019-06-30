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

data "google_container_cluster" "primary" {
  name   = "${module.cluster.name}"
  region = "${var.region}"
}

data "template_file" "kubeconfig" {
  template = "${file("${path.module}/kubeconfig.tpl")}"

  vars = {
    kubeconfig_name = "kubeconfig_${data.google_container_cluster.primary.name}"
    cluster_name    = "${data.google_container_cluster.primary.name}"
    user_name       = "${data.google_container_cluster.primary.master_auth.0.username}"
    user_password   = "${data.google_container_cluster.primary.master_auth.0.password}"
    endpoint        = "${data.google_container_cluster.primary.endpoint}"
    cluster_ca      = "${data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
    client_cert     = "${data.google_container_cluster.primary.master_auth.0.client_certificate}"
    client_cert_key = "${data.google_container_cluster.primary.master_auth.0.client_key}"
  }

  depends_on = ["module.cluster"]
}

resource "local_file" "kubeconfig" {
  content    = "${data.template_file.kubeconfig.rendered}"
  filename   = "./kubeconfig_${data.google_container_cluster.primary.name}"
  depends_on = ["module.cluster"]
}
