variable "cluster_identifier" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "database_name" {
  type = string
}
variable "master_username" {
  type = string
}
variable "master_password" {
  type      = string
  sensitive = true
}
variable "db_subnet_group_name" {
  type = string
}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "backup_retention_period" {
  type    = number
  default = 1
}
variable "deletion_protection" {
  type    = bool
  default = false
}
variable "publicly_accessible" {
  type    = bool
  default = true
}
variable "min_capacity" {
  type = number
}
variable "max_capacity" {
  type = number
}
variable "tags" {
  type    = map(string)
  default = {}
}