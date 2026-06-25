variable "name" {
  type = string
}
variable "description" {
  type    = string
  default = null
}
variable "secret_string" {
  type      = string
  sensitive = true
}
variable "kms_key_id" {
  type    = string
  default = null
}
variable "recovery_window_in_days" {
  type    = number
  default = 0
}
variable "tags" {
  type    = map(string)
  default = {}
}