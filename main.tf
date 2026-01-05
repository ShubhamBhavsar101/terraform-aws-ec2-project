# Main Terraform File

module "vpc" {
  source     = "./vpc"
  cidr_block = "11.0.0.0/16"
  tag_name   = "Terraform Test VPC"
}

module "rds_instance" {
  source = "./rds"
  rds_mysql_sg_id = module.security_group.rds_mysql_sg_id
  public_subnet_ids = module.subnet.public_subnet_ids

}

module "internet_gateway" {
  source = "./internet-gateways"
  vpc_id = module.vpc.vpc_id
}

module "security_group" {
  source = "./security-groups"
  vpc_id = module.vpc.vpc_id
}

module "subnet" {
  source = "./subnets"
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source              = "./route-tables"
  vpc_id              = module.vpc.vpc_id
  gateway_id          = module.internet_gateway.gateway_id
  public_subnet_id_1a = module.subnet.public_subnet_id_1a
  public_subnet_id_1b = module.subnet.public_subnet_id_1b
}


module "server" {
  source                     = "./ec2"
  sg_allow_ssh_http_https_id = module.security_group.sg_allow_ssh_http_https_id
  sg_allow_8080_id           = module.security_group.sg_allow_8080_id
  public_subnet_ids          = module.subnet.public_subnet_ids
  iam_instance_profile = module.iam_role.secrets_manager_instance_profile
}

module "iam_role" {
  source = "./iam_role"
}

module "load_balancer" {
  source = "./load-balancers"

  tag_name                   = "Terraform-ALB"
  internal                   = false
  load_balancer_type         = "application"
  security_group             = module.security_group.sg_allow_ssh_http_https_id
  public_subnet_ids          = toset(module.subnet.public_subnet_ids)
  alb_target_group_arn       = module.target_group.alb_tg_attachment_arn
  acm_certificate_arn        = module.acm.apache_acm_certificate_arn
  enable_deletion_protection = false

  https_port     = 443
  https_protocol = "HTTPS"
  http_port      = 80
  http_protocol  = "HTTP"
  action_type    = "forward"

}

module "acm" {
  source = "./certificate_manager"

}

module "route53" {
  source                    = "./route53"
  domain_name               = "shubhambuilds.space"                       # Replace your domain name here
  dns_name                  = module.load_balancer.dns_name
  zone_id                   = module.load_balancer.zone_id
  domain_validation_options = module.acm.apache_domain_validation_options
}

module "target_group" {
  source               = "./target_groups"
  vpc_id               = module.vpc.vpc_id
  server_instance_ids = module.server.server_instance_ids
}
