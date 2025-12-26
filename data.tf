data "aws_acm_certificate" "this" {
  domain   = var.certificate_domain_name
  statuses = ["ISSUED"]
}
