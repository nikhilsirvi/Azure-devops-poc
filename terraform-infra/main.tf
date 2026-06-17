module "iam" {

  source = "./modules/IAM/lambda-role"

  role_name = "${local.name_prefix}-lambda-role-${var.environment}"

  tags = local.common_tags
}

module "lambda" {

  source = "./modules/lambda"

  lambda_name = "${local.name_prefix}-lambda-${var.environment}"

  runtime = var.lambda_runtime

  handler = var.lambda_handler

  lambda_zip_path = var.lambda_zip_path

  role_arn = module.iam.role_arn

  tags = local.common_tags
}
