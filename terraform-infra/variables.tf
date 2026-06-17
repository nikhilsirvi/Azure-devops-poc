variable "application_name" {
  type = string
  description = "Project name used for tagging and resource naming"
}

variable "owner" {
  type = string
}

variable "lambda_runtime" {
  type = string
}

variable "lambda_handler" {
  type = string
  description = "Name of the Lambda function to create"
}

variable "lambda_zip_path" {
  type = string
}

variable "aws_region" {
  type        = string
  description = "AWS region where all resources will be deployed"
  default     = "ca-central-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (e.g. dev, qa, prod)"
}
