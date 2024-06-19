locals {
  helm_values = [{
    traefik = {
      service = {
        type = "LoadBalancer"
        annotations = {
          "service.beta.kubernetes.io/scw-loadbalancer-id" = var.lb_id
        }
      }
    }
  }]
}

