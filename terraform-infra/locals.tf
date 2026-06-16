locals {

  name_prefix = var.application_name

  common_tags = {
    Name        = local.name_prefix
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner

    ManagedBy  = "Terraform"
    Deployment = "IaC"
  }
} 