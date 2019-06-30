output "name" {
  description = "Cluster name"
  value       = "${module.cluster.name}"
}

output "type" {
  description = "Cluster type (regional / zonal)"
  value       = "${module.cluster.type}"
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = "${module.cluster.location}"
}

output "region" {
  description = "Cluster region"
  value       = "${module.cluster.region}"
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = "${module.cluster.zones}"
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = "${module.cluster.endpoint}"
}

output "min_master_version" {
  description = "Minimum master kubernetes version"
  value       = "${module.cluster.min_master_version}"
}

output "logging_service" {
  description = "Logging service used"
  value       = "${module.cluster.logging_service}"
}

output "monitoring_service" {
  description = "Monitoring service used"
  value       = "${module.cluster.monitoring_service}"
}

output "master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = "${module.cluster.master_authorized_networks_config}"
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = "${module.cluster.master_version}"
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = "${module.cluster.ca_certificate}"
}

output "network_policy_enabled" {
  description = "Whether network policy enabled"
  value       = "${module.cluster.network_policy_enabled}"
}

output "http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = "${module.cluster.http_load_balancing_enabled}"
}

output "horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = "${module.cluster.horizontal_pod_autoscaling_enabled}"
}

output "kubernetes_dashboard_enabled" {
  description = "Whether kubernetes dashboard enabled"
  value       = "${module.cluster.kubernetes_dashboard_enabled}"
}

output "node_pools_names" {
  description = "List of node pools names"
  value       = "${module.cluster.node_pools_names}"
}

output "node_pools_versions" {
  description = "List of node pools versions"
  value       = "${module.cluster.node_pools_versions}"
}

output "service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = "${module.cluster.service_account}"
}

output "master_instance_sql_ipv4" {
  value       = "${module.db.master_instance_sql_ipv4}"
  description = "The IPv4 address assigned for master"
}

output "master_instance_sql_name" {
  value       = "${module.db.master_instance_sql_name}"
  description = "The database name for master"
}

output "master_private_ip" {
  description = "The private IPv4 address of the master instance"
  value       = "${module.db.master_private_ip}"
}

output "master_instance" {
  description = "Self link to the master instance"
  value       = "${module.db.master_instance}"
}

output "master_ip_addresses" {
  description = "All IP addresses of the master instance JSON encoded, see https://www.terraform.io/docs/providers/google/r/sql_database_instance.html#ip_address-0-ip_address"
  value       = "${module.db.master_ip_addresses}"
}

/*output "kubeconfig" {
  value = "${data.template_file.kubeconfig.rendered}"
}*/

