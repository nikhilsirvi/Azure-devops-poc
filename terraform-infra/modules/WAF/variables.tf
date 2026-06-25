variable "name" {
  type = string
}
variable "scope" {
  type = string
}
variable "rate_limit" {
  type    = number
  default = 2000
}
variable "tags" {
  type    = map(string)
  default = {}
}