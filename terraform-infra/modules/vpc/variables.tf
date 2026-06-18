variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "myvpc"
}

variable "vpc_name" {
  type        = string
  default     = "vpc-name"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Map of AZ → CIDR for public subnets"
  type        = map(string)
  default = {
    "ap-south-1a" = "10.0.1.0/24"
    "ap-south-1b" = "10.0.2.0/24"
  }
}

variable "private_subnets" {
  description = "Map of AZ → CIDR for private subnets"
  type        = map(string)
  default = {
    "ap-south-1a" = "10.0.11.0/24"
    "ap-south-1b" = "10.0.12.0/24"
  }
}

variable "enable_nat_gateway" {
  description = "Create NAT gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to use a single NAT Gateway across all AZs"
  type        = bool
  default     = true
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "default-sg"
}

variable "sg_description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group"
}

variable "sg_ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    description     = optional(string)
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))
  default = []
}

variable "sg_egress_rules" {
  description = "List of egress rules"
  type = list(object({
    description     = optional(string)
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))
  default = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
