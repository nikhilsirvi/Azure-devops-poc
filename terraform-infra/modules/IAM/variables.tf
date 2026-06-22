variable "role_name" {
  type = string
}

variable "service_principal" {
  type = string
}

variable "managed_policy_arns" {
  type    = list(string)
  default = []
}

variable "tags" {
  type = map(string)
}