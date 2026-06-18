variable "name" {}
variable "description" {}
variable "vpc_id" {}

variable "ingress_rules" {
  type = list(any)
}

variable "egress_rules" {
  type = list(any)
}