variable "cidr_block" {}
variable "tag_name" {}

resource "aws_vpc" "test_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.tag_name
  }
}

output "vpc_id" {
  value = aws_vpc.test_vpc.id
}
