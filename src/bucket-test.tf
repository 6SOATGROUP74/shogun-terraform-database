# Provedor da AWS
provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.67.0"
    }
  }
}

# Criação do banco de dados
variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

resource "aws_db_instance" "bancomysqlteste" {
  allocated_storage    = 20
  db_name              = "db_soat"
  engine               = "mysql"
  engine_version       = "8.0.37"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

# Criação do Bucket S3
resource "aws_s3_bucket" "imai-labs-teste-superior" {
  bucket = "imai-labs-teste"  # O nome do bucket deve ser único em toda a AWS.

  tags = {
    Name        = "MeuBucketDeTeste"
    Environment = "Dev"
  }
}
