variable "name" {}
variable "description" {}
variable "vpc_id" {}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr        = optional(string)
    source_sg_id = optional(string)
  }))
}

variable "egress_rules" {
  type = list(any)
}

variable "tags" {
  type    = map(string)
  default = {}
}