aws_region       = "us-west-2"
environment      = "dev"
application_name = "mdt-cst-gaitway"
owner            = "devops-team"

lambda_runtime = "python3.12"
lambda_handler = "app.lambda_handler"

lambda_zip_path = "../Lambda/test-function/app.zip"



alb_sg = "sg-111111"

ecs_sg = "sg-222222"

namespace = "default"

secret_arn = "arn:aws:secretsmanager:ca-central-1:123456789012:secret:test"

account_id = "123456789012"