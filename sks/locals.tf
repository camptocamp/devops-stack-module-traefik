locals {
  helm_values = [{
    traefik = {
      service = {
        annotations = {
          "service.beta.kubernetes.io/exoscale-loadbalancer-id"                      = var.nlb_id
          "service.beta.kubernetes.io/exoscale-loadbalancer-external"                = "true"
          "service.beta.kubernetes.io/exoscale-loadbalancer-service-instancepool-id" = var.target_instance_pool_id
        }
      }
      nodeSelector = {
        "node.exoscale.net/nodepool-id" = var.target_nodepool_id
      }
    }
  }]
}
