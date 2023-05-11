locals {
  helm_values = [{
    traefik = {
      deployment = {
        replicas = var.replicas
      }
      metrics = {
        prometheus = {
          service = {
            enabled = true
          }
          serviceMonitor = {
            enabled = true
          }
        }
      }
      additionalArguments = [
        "--metrics.prometheus=true",
        "--serversTransport.insecureSkipVerify=true"
      ]
      logs = {
        access = {
          enabled = true
        }
      }
      tlsOptions = {
        default = {
          minVersion = "VersionTLS12"
        }
      }
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
}
