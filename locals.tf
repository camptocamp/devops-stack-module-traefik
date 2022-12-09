locals {
  helm_values = [{
    traefik = {
      ressources = {
        limits = {
          cpu    = "250m"
          memory = "512Mi"
        }
        requests = {
          cpu    = "125m"
          memory = "256Mi"
        }
      }
      middlewares = {
        redirections = {
          withclustername = {
            permanent   = false
            regex       = "apps.${var.base_domain}"
            replacement = "apps.${var.cluster_name}.${var.base_domain}"
          }
        }
      }
    }
  }]

  autosync = var.app_autosync ? { "allow_empty" = false, "prune" = true, "self_heal" = true } : {}

}
