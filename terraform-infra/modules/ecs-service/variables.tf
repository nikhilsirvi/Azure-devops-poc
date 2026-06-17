variable "name" { type = string }

variable "cluster_id" { type = string }

variable "image" { type = string }

variable "private_subnets" {
  type = list(string)
}

variable "ecs_sg" { type = string }

variable "target_group_arn" { type = string }

variable "listener_arn" { type = string }

variable "namespace" { type = string }

variable "execution_role_arn" { type = string }

variable "task_role_arn" { type = string }

variable "secret_arn" {type = string}
variable "region" {type = string}
variable "account_id" {type = string}