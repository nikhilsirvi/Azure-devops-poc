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
  default     = "us-west-2"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (e.g. dev, qa, prod)"
}

variable "alb_sg" {
  type = string
}

variable "ecs_sg" {
  type = string
}

variable "namespace" {
  type = string
}

variable "secret_arn" {
  type = string
}

variable "account_id" {
  type = string
}