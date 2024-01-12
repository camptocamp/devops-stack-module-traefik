module "traefik" {
  source = "../"

  cluster_name             = var.cluster_name
  base_domain              = var.base_domain
  argocd_project           = var.argocd_project
  argocd_labels            = var.argocd_labels
  destination_cluster      = var.destination_cluster
  target_revision          = var.target_revision
  enable_service_monitor   = var.enable_service_monitor
  app_autosync             = var.app_autosync
  enable_https_redirection = var.enable_https_redirection

  helm_values = concat(local.helm_values, var.helm_values)

  dependency_ids = var.dependency_ids
}
