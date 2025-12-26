
output "region" {
  description = "AWS region for all resources."
  value       = var.region
}

output "alb_arn" {
  description = "ARN of ALB"
  value       = aws_lb.this.arn
}
