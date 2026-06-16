variable "lambda_name" {
  type = string
}

variable "runtime" {
  type = string
}

variable "handler" {
  type = string
}

variable "lambda_zip_path" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}