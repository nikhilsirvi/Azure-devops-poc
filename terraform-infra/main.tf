// IAM call

module "lambda_role" {
  source = "./modules/IAM"

  role_name        = "${local.name_prefix}-${var.environment}-lambda-role"
  service_principal = "lambda.amazonaws.com"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  tags = local.common_tags
}

module "ecs_execution_role" {
  source = "./modules/IAM"

  role_name        = "${local.name_prefix}-${var.environment}-ecs-execution-role"
  service_principal = "ecs-tasks.amazonaws.com"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
  tags = local.common_tags
}

module "ecs_task_role" {
  source = "./modules/IAM"

  role_name        = "${local.name_prefix}-${var.environment}-ecs-task-role"
  service_principal = "ecs-tasks.amazonaws.com"

  tags = local.common_tags
}


// lambda call
module "lambda" {

  source = "./modules/lambda"

  lambda_name = "${local.name_prefix}-${var.environment}-lambda"

  runtime = var.lambda_runtime

  handler = var.lambda_handler

  lambda_zip_path = var.lambda_zip_path

  role_arn = module.lambda_role.role_arn

  tags = local.common_tags
}

// ecr call
module "ecr" {

  source = "./modules/ecr"

  name = "${local.name_prefix}-${var.environment}-repo"

  tags = local.common_tags
}


// abl call
module "alb" {

  source = "./modules/alb"

  name = "${local.name_prefix}-${var.environment}-alb"

  vpc_id = module.vpc.vpc_id

  private_subnets = module.vpc.private_subnet_ids

  alb_sg = module.alb_sg.security_group_id

  target_port = 3000

  tags = local.common_tags
}

// ecs cluster call
module "ecs_cluster" {

  source = "./modules/ecs-cluster"

  name = "${local.name_prefix}-${var.environment}-cluster"

  tags = local.common_tags
}


// ECS service call
module "ecs_service" {

  source = "./modules/ecs-service"

  name = "${local.name_prefix}-${var.environment}"

  cluster_id = module.ecs_cluster.cluster_id

  image = "${module.ecr.repository_url}:latest"

  private_subnets = module.vpc.private_subnet_ids

  ecs_sg = module.alb_sg.security_group_id

  target_group_arn = module.alb.target_group_arn

  listener_arn = module.alb.listener_arn

  namespace = var.namespace

  execution_role_arn = module.ecs_execution_role.role_arn

  task_role_arn = module.ecs_task_role.role_arn

  secret_arn = var.secret_arn

  region = var.aws_region

  account_id = var.account_id
}


//VPC call
module "vpc" {
  source = "./modules/vpc"

  vpc-name = "${local.name_prefix}-${var.environment}"


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


// ALB security group
module "alb_sg" {
  source = "./modules/security-group"

  name        = "${local.name_prefix}-${var.environment}-alb"
  description = "Security Group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr      = "0.0.0.0/0"
    },
    {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      cidr      = "0.0.0.0/0"
    },
    {
      from_port = 3000
      to_port   = 3000
      protocol  = "tcp"
      cidr      = "0.0.0.0/0"
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

// ECS-sg call
module "ecs_sg" {
  source = "./modules/security-group"

  name        = "${local.name_prefix}-${var.environment}-ecs"
  description = "Security Group for ECS Tasks"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
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


module "frontend_bucket" {
  source = "./modules/s3-frontend"

  bucket_name = "${local.name_prefix}-${var.environment}-frontend-bucket"

 
}

module "cloudfront" {
  source = "./modules/cloudfront"

  project_name                = "${local.name_prefix}-${var.environment}-CDN"

  bucket_id                   = module.frontend_bucket.bucket_id
  bucket_arn                  = module.frontend_bucket.bucket_arn
  bucket_regional_domain_name = module.frontend_bucket.bucket_regional_domain_name
  
}