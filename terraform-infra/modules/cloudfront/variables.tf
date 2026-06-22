variable "project_name" {
  description = "Project name"
  type        = string
}

variable "bucket_id" {
  description = "S3 bucket id"
  type        = string
}

variable "bucket_arn" {
  description = "S3 bucket ARN"
  type        = string
}

variable "bucket_regional_domain_name" {
  description = "Regional domain name of S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply on resources"
  type        = map(string)
  default     = {}
}