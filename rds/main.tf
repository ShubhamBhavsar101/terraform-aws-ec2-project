variable "rds_mysql_sg_id" {}
variable "public_subnet_ids" {}
# variable "db_password" {
#   type = string
#   sensitive = true
# }

resource "aws_db_instance" "mysql" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username = "dbuser"
  manage_master_user_password = true
  # password             = var.db_password
#   parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  apply_immediately = true
  deletion_protection = false
  vpc_security_group_ids = [var.rds_mysql_sg_id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

}

# output rds_secret_name {
#   value = split(":", aws_db_instance.mysql.master_user_secret[0].secret_arn)[6]
# }

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "terraform-sqldb-subnet-group"
  subnet_ids = var.public_subnet_ids
}

# resource "aws_secretsmanager_secret" "db_metadata" {
#   name = "mysql-db-metadata"
# }

# resource "aws_secretsmanager_secret_version" "db_metadata_value" {
#   secret_id = aws_secretsmanager_secret.db_metadata.id

#   secret_string = jsonencode({
#     db_name  = aws_db_instance.mysql.db_name
#     host     = aws_db_instance.mysql.address
#     port     = aws_db_instance.mysql.port
#     username = aws_db_instance.mysql.username
#   })
# }

resource "aws_ssm_parameter" "db_host" {
  name  = "/db/mysql/host"
  type  = "String"
  value = aws_db_instance.mysql.address
}

resource "aws_ssm_parameter" "db_name" {
  name = "/db/mysql/db_name"
  type = "String"
  value = aws_db_instance.mysql.db_name
}

resource "aws_ssm_parameter" "rds_secret_name" {
  name = "/db/mysql/rds_secret_name"
  type = "String"
  value = aws_db_instance.mysql.master_user_secret[0].secret_arn
}