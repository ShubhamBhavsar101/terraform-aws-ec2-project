variable "vpc_id" {
  type = string
  description = "VPC ID where the security group will be created"
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = var.vpc_id
  cidr_block = "11.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Terraform Test1 Public Subnet"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = var.vpc_id
  cidr_block = "11.0.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Terraform Test2 Public Subnet"
  }
}


output "public_subnet_ids" {
    value = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "public_subnet_id_1a" {
  value = aws_subnet.public_subnet_1.id
}

output "public_subnet_id_1b" {
  value = aws_subnet.public_subnet_2.id
}