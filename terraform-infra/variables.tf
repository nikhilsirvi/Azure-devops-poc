# AWS
variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
  default = "us-west-2"
}
# Project Metadata
variable "environment" {
  description = "Deployment environment"
  type        = string
  default = "dev"
}
variable "application_name" {
  description = "Application name"
  type        = string
}
variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
}
# Networking
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}
variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}
variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
}
# ECS / Application
variable "namespace" {
  description = "Cloud Map namespace"
  type        = string
  default = "default"
}
variable "app_port" {
  description = "Application container port"
  type        = number
  default = 3000
}
# Lambda
variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
}
variable "lambda_handler" {
  description = "Lambda handler"
  type        = string
}
variable "lambda_zip_path" {
  description = "Path to Lambda zip package"
  type        = string
}
# Aurora PostgreSQL
variable "database_name" {
  description = "Aurora database name"
  type        = string
  default = "gaitway"
}
variable "db_username" {
  description = "Aurora master username"
  type        = string
  default = "postgres"
}
variable "db_password" {
  description = "Aurora master password"
  type        = string
  sensitive   = true
}
variable "aurora_engine_version" {
  description = "Aurora PostgreSQL engine version"
  type        = string
  default = "17.7"
}
variable "aurora_min_capacity" {
  description = "Aurora Serverless minimum ACU"
  type        = number
  default = 0
}
variable "aurora_max_capacity" {
  description = "Aurora Serverless maximum ACU"
  type        = number
  default = 2
}
variable "backup_retention_period" {
  description = "Aurora backup retention days"
  type        = number
  default = 1
}
variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default = false
}
variable "publicly_accessible" {
  description = "Whether Aurora instances are publicly accessible"
  type        = bool
  default = false
}
# WAF
variable "api_gateway_rate_limit" {
  description = "WAF rate limit for API Gateway"
  type        = number
  default = 2000
}
variable "assume_role_arn" {
  description = "Role assumed by Terraform"
  type        = string
}