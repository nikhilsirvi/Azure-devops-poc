variable "bucket_name" {
  description = "Frontend S3 bucket name"
  type        = string
}

variable "tags" {
  description = "Tags to apply on resources"
  type        = map(string)
  default     = {}
}