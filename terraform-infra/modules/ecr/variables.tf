variable "name" {
  description = "ECR repository name"
  type        = string
}
variable "image_tag_mutability" {
  type    = string
  default = "MUTABLE"
}
variable "scan_on_push" {
  type    = bool
  default = true
}
variable "enable_lifecycle_policy" {
  type    = bool
  default = true
}
variable "max_image_count" {
  type    = number
  default = 10
}
variable "tags" {
  type    = map(string)
  default = {}
}