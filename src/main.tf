# Provedor da AWS
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }
}

resource "aws_db_instance" "shogun_data_base" {


  depends_on = [
    aws_secretsmanager_secret.ssm_rds,aws_security_group_rule.allow_mysql_ingress
  ]

  allocated_storage      = 20
  db_name                = "db_soat"
  identifier             = "shogun-database"
  engine                 = "mysql"
  engine_version         = "8.0.37"
  instance_class         = "db.t3.micro"
  username               = jsondecode(aws_secretsmanager_secret_version.ssm_rds_version.secret_string)["username"]
  password               = jsondecode(aws_secretsmanager_secret_version.ssm_rds_version.secret_string)["password"]
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_secretsmanager_secret" "ssm_rds" {
  description = "RDS MySQL"
}

resource "aws_secretsmanager_secret_version" "ssm_rds_version" {

  secret_id = aws_secretsmanager_secret.ssm_rds.id
  secret_string = jsonencode({
    username = "tech_user"
    password = "tech_password"
  })
}

resource "aws_security_group_rule" "allow_mysql_ingress" {

  depends_on = [
    aws_security_group.rds_sg
  ]

  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "rds_sg" {
  name        = "shogun-rds-security-group"
  description = "Security group for RDS MySQL"
  vpc_id      = data.aws_vpc.this.id
}

data "aws_vpc" "this" {
  default = true
}