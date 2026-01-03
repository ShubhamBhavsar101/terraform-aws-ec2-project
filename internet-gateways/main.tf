variable "vpc_id" {}

resource "aws_internet_gateway" "tf_test_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Terraform Test Internet Gateway"
  }
}

output "gateway_id" {
    value = aws_internet_gateway.tf_test_igw.id
}