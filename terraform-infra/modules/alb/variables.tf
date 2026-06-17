variable "name" {
  description = "ALB name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs (min 2 AZs)"
  type        = list(string)
}

variable "alb_sg" {
  description = "Security group for ALB"
  type        = string
}

variable "listener_port" {
  description = "Listener port"
  type        = number
  default     = 80
}

variable "target_port" {
  description = "Target group port"
  type        = number
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}