variable "nlb_id" {
  description = "ID of the Exoscale NLB to use for the SKS cluster."
  type        = string
}

variable "target_nodepool_id" {
  description = "ID of the target node pool."
  type        = string
}

variable "target_instance_pool_id" {
  description = "Instance pool ID of the target node pool."
  type        = string
}
