module "traefik" {
  source = "../hostport/"

  cluster_name     = var.cluster_name
  base_domain      = var.base_domain
  argocd_namespace = var.argocd_namespace

  namespace = var.namespace

  extra_yaml = concat([templatefile("${path.module}/values.tmpl.yaml", {})], var.extra_yaml)
}
