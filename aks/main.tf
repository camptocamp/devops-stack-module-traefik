data "azurerm_dns_zone" "this" {
  name                = var.base_domain
  resource_group_name = var.dns_zone_resource_group_name
}

data "azurerm_resource_group" "nodes_resource_group" {
  name = var.node_resource_group_name
}

# TODO should we move this out of here?
resource "azurerm_dns_cname_record" "wildcard" {
  name                = "*.apps.${var.cluster_name}"
  zone_name           = data.azurerm_dns_zone.this.name
  resource_group_name = data.azurerm_dns_zone.this.resource_group_name
  ttl                 = 300
  record              = "${local.azure_dns_label_name}.${data.azurerm_resource_group.nodes_resource_group.location}.cloudapp.azure.com."
}

module "traefik" {
  source = "../"

  cluster_name           = var.cluster_name
  base_domain            = var.base_domain
  argocd_namespace       = var.argocd_namespace
  argocd_project         = var.argocd_project
  argocd_labels          = var.argocd_labels
  destination_cluster    = var.destination_cluster
  target_revision        = var.target_revision
  namespace              = var.namespace
  enable_service_monitor = var.enable_service_monitor
  app_autosync           = var.app_autosync

  helm_values = concat(local.helm_values, var.helm_values)

  dependency_ids = var.dependency_ids
}
