// VPC 
module "vpc" {
  source = "./modules/vpc"
  vpc-name = local.name_prefix
  vpc_cidr = "10.0.0.0/16"
  availability_zones = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c"
  ]
  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24"
  ]
}
// security group
module "alb_sg" {
  source = "./modules/security-group"
  name        = "${local.name_prefix}-alb"
  description = "Security Group for ALB"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr_ipv4 = "10.0.0.0/16"
    },
    {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      cidr_ipv4 = "10.0.0.0/16"
    }
  ]
  egress_rules = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr      = "0.0.0.0/0"
    }
  ]
}
module "ecs_sg" {
  source = "./modules/security-group"
  name        = "${local.name_prefix}-ecs"
  description = "Security Group for ECS Tasks"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port    = local.app_port
      to_port      = local.app_port
      protocol     = "tcp"
      source_sg_id = module.alb_sg.security_group_id
    }
  ]
  egress_rules = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr      = "0.0.0.0/0"
    }
  ]
}
module "aurora_sg" {
  source = "./modules/security-group"
  name        = "${local.name_prefix}-postgres"
  description = "Security Group for Aurora PostgreSQL"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port    = 5432
      to_port      = 5432
      protocol     = "tcp"
      source_sg_id = module.ecs_sg.security_group_id
    }
  ]
  egress_rules = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr      = "0.0.0.0/0"
    }
  ]
}
module "api_gateway_sg" {
  source = "./modules/security-group"
  name        = "${local.name_prefix}-api-gateway"
  description = "Security Group for API Gateway"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_ipv4   = "10.0.0.0/16"
      description = "HTTPS"
    }
  ]
  egress_rules = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr      = "0.0.0.0/0"
    }
  ]
}
// IAM roles
module "lambda_role" {
  source = "./modules/IAM"
  role_name         = "${local.name_prefix}-lambda-role"
  service_principal = "lambda.amazonaws.com"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
  tags = local.common_tags
}
module "ecs_execution_role" {
  source = "./modules/IAM"
  role_name         = "${local.name_prefix}-ecs-execution-role"
  service_principal = "ecs-tasks.amazonaws.com"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
  tags = local.common_tags
}
module "ecs_task_role" {
  source = "./modules/IAM"
  role_name         = "${local.name_prefix}-ecs-task-role"
  service_principal = "ecs-tasks.amazonaws.com"
  tags = local.common_tags
}
// S3 bucket
module "frontend_bucket" {
  source = "./modules/s3-frontend"
  bucket_name = "${local.name_prefix}-frontend-bucket"
}
// subnet group for database
module "db_subnet_group" {
  source = "./modules/db-subnet-group"
  name = "${local.name_prefix}-subnet-group"
  subnet_ids = module.vpc.private_subnet_ids
}
// Secret Manager
module "db_secret" {
  source = "./modules/secrets-manager"
  name        = "${local.name_prefix}/rds/postgres"
  description = "Aurora credentials"
  secret_string = jsonencode({
    username = "postgres"
    password = var.db_password
  })
}
// WAF for cloudfront
module "cloudfront_waf" {
  source = "./modules/WAF"
  providers = {
    aws = aws.virginia
  }
  name  = "${local.name_prefix}-cloudfront-waf"
  scope = "CLOUDFRONT"
}

// Lambda function
module "lambda" {
  source = "./modules/lambda"
  lambda_name = "${local.name_prefix}-lambda"
  runtime = var.lambda_runtime
  handler = var.lambda_handler
  lambda_zip_path = var.lambda_zip_path
  role_arn = module.lambda_role.role_arn
  tags = local.common_tags
}
// ECR
module "ecr" {
  source = "./modules/ecr"
  name = "${local.name_prefix}-repo"
  tags = local.common_tags
}
// ECS cluster
module "ecs_cluster" {
  source = "./modules/ecs-cluster"
  name = "${local.name_prefix}-cluster"
  tags = local.common_tags
}
// Aurora postgres database
module "aurora" {
  source = "./modules/aurora-postgres"
  cluster_identifier = "${local.name_prefix}-database"
  engine_version = "17.7"
  database_name = "gaitway"
  master_username = "postgres"
  master_password = var.db_password
  db_subnet_group_name = module.db_subnet_group.name
  vpc_security_group_ids = [
    module.aurora_sg.security_group_id
  ]
  publicly_accessible = false
  min_capacity = 0
  max_capacity = 2
  backup_retention_period = 1
  deletion_protection = false
}
// Internal load balancer
module "alb" {
  source = "./modules/alb"
  name = "${local.name_prefix}-alb"
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  alb_sg = module.alb_sg.security_group_id
  target_port = local.app_port
  tags = local.common_tags
}
// API gateway
module "api_gateway" {
  source = "./modules/api-gateway"
  api_name = "${local.name_prefix}-api-gateway"
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_link_sg_id = module.api_gateway_sg.security_group_id
  alb_listener_arn = module.alb.listener_arn
  allow_origins = [
    "https://${module.cloudfront.distribution_domain_name}"
  ]
}
// cloudfront for frontent
module "cloudfront" {
  source = "./modules/cloudfront"
  project_name = "${local.name_prefix}-cdn"
  bucket_id                   = module.frontend_bucket.bucket_id
  bucket_arn                  = module.frontend_bucket.bucket_arn
  bucket_regional_domain_name = module.frontend_bucket.bucket_regional_domain_name
  waf_arn = module.cloudfront_waf.arn
}
// ECS service
module "ecs_service" {
  source = "./modules/ecs-service"
  name = local.name_prefix
  cluster_id = module.ecs_cluster.cluster_id
  image = "${module.ecr.repository_url}:latest"
  private_subnets = module.vpc.private_subnet_ids
  ecs_sg = module.ecs_sg.security_group_id
  target_group_arn = module.alb.target_group_arn
  listener_arn = module.alb.listener_arn
  namespace = var.namespace
  execution_role_arn = module.ecs_execution_role.role_arn
  task_role_arn = module.ecs_task_role.role_arn
  secret_arn = module.db_secret.secret_arn
  region = var.aws_region
  account_id = local.account_id
}
// SSM-parameter for backend api
module "backend_api_url" {
  source = "./modules/ssm-parameter"
  name  = "/${local.name_prefix}/backend/api-url"
  value = module.api_gateway.api_endpoint
}


