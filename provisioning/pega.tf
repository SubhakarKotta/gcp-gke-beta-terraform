/*module "pega" {
  kubernetes_provider = "eks"
  source              = "github.com/scrumteamwhitewalkers/terraform-pega-modules.git"
  name                = "${var.name}"
  wait_id             = "${kubernetes_cluster_role_binding.super-user.id}"
  namespace           = "${var.namespace}"
  release_name        = "${var.release_name}"
  chart_name          = "${var.chart_name}"
  chart_version       = "${var.chart_version}"
  deployment_timeout  = "7200"
  docker_password     = "${var.docker_password}"
  docker_username     = "${var.docker_username}"
  docker_url          = "https://index.docker.io/v1/"
  pega_repo_url       = "${var.pega_repo_url}"
  route53_zone        = "${var.route53_zone}"
  enable_dashboard    = true
  jdbc_url            = "jdbc:postgresql://${module.db.this_db_instance_endpoint}/${module.db.this_db_instance_name}"
}*/

