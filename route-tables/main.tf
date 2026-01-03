variable "vpc_id" {}
variable "gateway_id" {}
variable "public_subnet_id_1a" {}
variable "public_subnet_id_1b" {}

resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  tags = {
    Name = "Terraform Test Route"
  }
}

resource "aws_route_table_association" "public_subnet_association_1a" {
  subnet_id      = var.public_subnet_id_1a
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_association_1b" {
  subnet_id      = var.public_subnet_id_1b
  route_table_id = aws_route_table.public_rt.id
}

