output "id" {
  value = module.traefik.id
}

output "external_ip" {
  description = "External IP address of Traefik LB service."
  value       = data.kubernetes_service.traefik.status.0.load_balancer.0.ingress.0.ip
}
