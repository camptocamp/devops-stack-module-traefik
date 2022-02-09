variable "vpc_id" {
  description = "VPC where the cluster and workers will be deployed."
  type        = string
}

variable "create_public_nlb" {
  description = "Whether to create an internet-facing NLB attached to the public subnets"
  type        = bool
  default     = true
}

variable "create_private_nlb" {
  description = "Whether to create an internal NLB attached the private subnets"
  type        = bool
  default     = false
}

variable "extra_lb_target_groups" {
  description = "Additional load-balancer target groups"
  type        = list(any)
  default     = []
}

variable "extra_lb_http_tcp_listeners" {
  description = "Additional load-balancer listeners"
  type        = list(any)
  default     = []
}
