variable "region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-2"
}

variable "alb_name" {
  description = "Unique name to assign to ALB."
  type        = string
}

variable "certificate_domain_name" {
  description = "Certificate domain name."
  type        = string
}

variable "vpc_id" {
  description = "VPC for LB."
  type        = string
}

variable "listener" {
  type = object({
    ingress_port        = number
    ssl_certificate_arn = string
    protocol            = string
  })
}

variable "subnets" {
  type        = list(string)
  description = "List of Subnet ID"
}