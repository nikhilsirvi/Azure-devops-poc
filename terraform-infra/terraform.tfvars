# AWS
aws_region = "us-west-2"
# Project Metadata
environment      = "dev"
application_name = "mdt-cst-gaitway"
owner            = "devops-team"
# Provider
assume_role_arn = "arn:aws:iam::885996153081:role/mdt_devsecops_cst"
# Networking
vpc_cidr = "10.0.0.0/16"
availability_zones = [
  "us-west-2a",
  "us-west-2b",
  "us-west-2c"
]
public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]
private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24",
  "10.0.13.0/24"
]
# ECS
namespace = "default"
app_port = 3000
# Lambda
lambda_runtime = "python3.12"
lambda_handler = "app.lambda_handler"
lambda_zip_path = "../Lambda/test-function/app.zip"
# Aurora PostgreSQL
database_name = "gaitway"
db_username = "postgres"
db_password = "gaitway1234"
aurora_engine_version = "17.7"
aurora_min_capacity = 0
aurora_max_capacity = 2
backup_retention_period = 1
deletion_protection = false
publicly_accessible = false
# WAF
api_gateway_rate_limit = 2000