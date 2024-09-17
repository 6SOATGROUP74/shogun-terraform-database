# Provedor da AWS
provider "aws" {
  region  = "sa-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.67.0"
    }
  }

  backend "s3" {

  }
}

# Criação do Bucket S3
resource "aws_s3_bucket" "imai-labs-teste-superior" {
  bucket = "imai-labs-teste"  # O nome do bucket deve ser único em toda a AWS

  tags = {
    Name        = "MeuBucketDeTeste"
    Environment = "Dev"
  }
}
