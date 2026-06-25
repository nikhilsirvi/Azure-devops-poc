variable "name" {
  type = string
}
variable "value" {
  type      = string
  sensitive = true
}
variable "type" {
  type    = string
  default = "SecureString"
}
variable "tier" {
  type    = string
  default = "Standard"
}
variable "tags" {
  type    = map(string)
  default = {}
}