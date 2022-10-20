variable "resource_group_name" {
  description = "The Resource Group where the DNS Zone exists. DNS Zone is updated with CNAME *.apps.cluster_name -> load balancer's FQDNs. This RG and AKS's RG must be in the same location."
  type        = string
}
