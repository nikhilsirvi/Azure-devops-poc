locals {
  account_id = data.aws_caller_identity.current.account_id
  name_prefix = "${var.application_name}-${var.environment}"
  app_port = var.app_port
  common_tags = {
    Name        = local.name_prefix
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    ManagedBy  = "Terraform"
    Deployment = "IaC"
  }
} 