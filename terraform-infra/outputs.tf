output "lambda_name" {
  value = module.lambda.lambda_name
}

output "lambda_arn" {
  value = module.lambda.lambda_arn
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ecs_service_name" {
  value = module.ecs_service.service_name
}