variable "vpc_id" {
    type = string
    description = "VPC ID where the security group will be created"
}


resource "aws_security_group" "sg_allow_ssh_http_https" {
  name        = "Terraform Test SG for Port 80, 443 and 22"
  # description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Terraform Test SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tf_test_allow_https" {
  security_group_id = aws_security_group.sg_allow_ssh_http_https.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags = {
    Name = "Terraform Test - Allow HTTPS IPv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tf_test_allow_http" {
  security_group_id = aws_security_group.sg_allow_ssh_http_https.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags = {
    Name = "Terraform Test - Allow HTTP IPv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tf_test_allow_ssh" {
  security_group_id = aws_security_group.sg_allow_ssh_http_https.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = {
    Name = "Terraform Test - Allow SSH IPv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ports" {
  security_group_id = aws_security_group.sg_allow_ssh_http_https.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5000
  ip_protocol       = "tcp"
  to_port           = 10000
  tags = {
    Name = "Terraform Test - Allow Ports to Connect"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_egress_traffic_ipv4" {
  security_group_id = aws_security_group.sg_allow_ssh_http_https.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  tags = {
    Name = "Terraform Egress Rule"
  }
}

output "sg_allow_ssh_http_https_id" {
  value = aws_security_group.sg_allow_ssh_http_https.id
}

########################################################

resource "aws_security_group" "sg_allow_8080" {
  name        = "Terraform Test SG for Port 8080"
  # description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Terraform Test SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_8080_rule" {
  security_group_id = aws_security_group.sg_allow_8080.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 8080
  to_port = 8080
  ip_protocol = "tcp"
  tags = {
    Name = "Terraform Allow 8080"
  }
}

output "sg_allow_8080_id" {
  value = aws_security_group.sg_allow_8080.id
}

########################################################

# Security Group for RDS
resource "aws_security_group" "rds_mysql_sg" {
  name        = "rds-sg"
  description = "Allow access to RDS from EC2 present in public subnet"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_mysql_db" {
  security_group_id = aws_security_group.rds_mysql_sg.id
  referenced_security_group_id = aws_security_group.sg_allow_ssh_http_https.id
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
  tags = {
    Name = "Allow MySQL DB - Terraform"
  }
}

output "rds_mysql_sg_id" {
  value = aws_security_group.rds_mysql_sg.id
}