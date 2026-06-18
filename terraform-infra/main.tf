// IAM call
module "iam" {

  source = "./modules/IAM/lambda-role"

  role_name = "${local.name_prefix}-lambda-role-${var.environment}"

  tags = local.common_tags
}

// lambda call
module "lambda" {

  source = "./modules/lambda"

  lambda_name = "${local.name_prefix}-lambda-${var.environment}"

  runtime = var.lambda_runtime

  handler = var.lambda_handler

  lambda_zip_path = var.lambda_zip_path

  role_arn = module.iam.role_arn

  tags = local.common_tags
}

// ecr call
module "ecr" {

  source = "./modules/ecr"

  name = "${local.name_prefix}-repo-${var.environment}"

  tags = local.common_tags
}


// abl call
module "alb" {

  source = "./modules/alb"

  name = "${local.name_prefix}-alb-${var.environment}"

  vpc_id = var.vpc_id

  private_subnets = var.private_subnets

  alb_sg = var.alb_sg

  target_port = 8000

  tags = local.common_tags
}

// ecs cluster call
module "ecs_cluster" {

  source = "./modules/ecs-cluster"

  name = "${local.name_prefix}-cluster-${var.environment}"

  tags = local.common_tags
}


// ECS service call
module "ecs_service" {

  source = "./modules/ecs-service"

  name = "${local.name_prefix}-service-${var.environment}"

  cluster_id = module.ecs_cluster.cluster_id

  image = "${module.ecr.repository_url}:latest"

  private_subnets = var.private_subnets

  ecs_sg = var.ecs_sg

  target_group_arn = module.alb.target_group_arn

  listener_arn = module.alb.listener_arn

  namespace = var.namespace

  execution_role_arn = module.iam.role_arn

  task_role_arn = module.iam.role_arn

  secret_arn = var.secret_arn

  region = var.aws_region

  account_id = var.account_id
}


//VPC call
module "vpc" {
  source = "./modules/vpc"

  project_name = "gaitway"
  environment  = "dev"

  vpc_cidr = "10.0.0.0/16"

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b",
    "ap-south-1c"
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