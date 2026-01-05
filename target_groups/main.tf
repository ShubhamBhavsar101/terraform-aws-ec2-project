variable "vpc_id" {}
variable "server_instance_ids" {}

resource "aws_lb_target_group" "jenkins_alb_tg" {
    name     = "Terraform-ALB-Target-Group"
    port     = 5000
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    health_check {
        path = "/"
        port = "5000"
        protocol = "HTTP"
        healthy_threshold = 6
        unhealthy_threshold = 2
        timeout = 2
        interval = 5
        matcher = "200" # has to be HTTP 200 or fails
    }
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
    count = length(var.server_instance_ids)
    target_group_arn = aws_lb_target_group.jenkins_alb_tg.arn
    target_id        = var.server_instance_ids[count.index]
    port             = 5000
}

output "alb_tg_attachment_arn" {
  value = aws_lb_target_group.jenkins_alb_tg.arn
}
