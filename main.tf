# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      HashiCorpLearnTutorial = "no-code-modules"
    }
  }
}

provider "random" {}

data "aws_availability_zones" "available" {}

resource "random_pet" "random" {}


resource "aws_lb" "this" {
  name                       = var.alb_name
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.this.id]
  subnets                    = var.subnets
  enable_deletion_protection = true
  drop_invalid_header_fields = true

  tags = {
    Environment = "dev"
    Terraform   = "NoCodeDemo"
  }
}


resource "aws_security_group" "this" {
  name   = "${random_pet.random.id}-${var.alb_name}"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["192.80.0.0/16"]
  }

  egress {
    from_port   = 443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn        = aws_lb.this.arn
  port                     = var.listener.ingress_port
  protocol                 = var.listener.protocol
  tcp_idle_timeout_seconds = try(var.listener.tcp_idle_timeout, null)
  ssl_policy               = "ELBSecurityPolicy-2016-08"
  certificate_arn          = data.aws_acm_certificate.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  port        = var.listener.ingress_port
  protocol    = var.listener.protocol
  target_type = "ip"

  health_check {
    enabled  = true
    protocol = "HTTPS"
    matcher  = "200-499"
  }
}


locals {
  # Increment db_password_version to update the DB password and store the new
  # password in SSM.
  db_password_version = 1
}
