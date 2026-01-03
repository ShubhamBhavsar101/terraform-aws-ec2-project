variable "sg_allow_ssh_http_https_id" {}
variable "sg_allow_8080_id" {}
variable "public_subnet_ids" {}
variable "iam_instance_profile" {}


resource "aws_instance" "server" {
  count = length(var.public_subnet_ids)
  
  ami                         = "ami-02b8269d5e85954ef" # Ubuntu - 24.04 - LTS - x86
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [var.sg_allow_8080_id, var.sg_allow_ssh_http_https_id]
  subnet_id                   = var.public_subnet_ids[count.index]
  key_name                    = "Macbook-AWS"
  associate_public_ip_address = true
  iam_instance_profile = var.iam_instance_profile
  # user_data = templatefile("./jenkins_runner_script/install.sh", {})
  user_data = templatefile("./runner_script/install_flask_app.sh", {})
  user_data_replace_on_change = true
  tags = {
    Name = "Terraform Server ${count.index}"
  }
}

output "server_instance_ids" {
  value = [for instance in aws_instance.server: instance.id]
}

output "server_instance_ips" {
  value = [for instance in aws_instance.server: instance.private_ip]
}