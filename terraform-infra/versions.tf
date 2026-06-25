terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket         = "mdt-cst-gaitway-terraform-state-01"
    key            = "terraform-infra/dev/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table   = "mdt-cst-gaitway-terraform-locks"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}