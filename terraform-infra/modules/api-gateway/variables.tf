variable "api_name" {
  type = string
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "vpc_link_sg_id" {
  type = string
}
variable "alb_listener_arn" {
  type = string
}
variable "allow_origins" {
  type = list(string)
  default = [
    "*"
  ]
}
variable "tags" {
  type    = map(string)
  default = {}
}
