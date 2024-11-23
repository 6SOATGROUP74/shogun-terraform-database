terraform {
  backend "s3" {
    bucket = "bucket-terraform-shogun-backend"
    key = "database/terraform.tfstate"
    region = "us-east-1"
  }
}