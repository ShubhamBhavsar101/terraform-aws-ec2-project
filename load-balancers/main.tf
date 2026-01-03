variable "security_group" {}
variable "public_subnet_ids" {}
variable "alb_target_group_arn" {}
variable "acm_certificate_arn" {}
variable "tag_name" {}
variable "internal" {}
variable "load_balancer_type" {}
variable "enable_deletion_protection" {}
variable "https_port" {}
variable "https_protocol" {}
variable "http_port" {}
variable "http_protocol" {}
variable "action_type" {}

####################################################################

resource "aws_lb" "alb" {
  name               = var.tag_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.security_group]
  subnets            = var.public_subnet_ids
  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Environment = "Development"
  }
}


resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.https_port
  protocol          = var.https_protocol
  certificate_arn   = var.acm_certificate_arn


  default_action {
    type             = var.action_type
    target_group_arn = var.alb_target_group_arn
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type             = var.action_type
    target_group_arn = var.alb_target_group_arn
  }
}

####################################################################

output "zone_id" {
    value = aws_lb.alb.zone_id
}

output "dns_name" {
    value = aws_lb.alb.dns_name
}