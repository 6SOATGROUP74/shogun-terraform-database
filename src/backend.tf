terraform {
  backend "s3" {
    bucket = "backend-terraform-shogun-fiap"
    key = "database/terraform.tfstate"
    region = "us-east-1"
  }
}