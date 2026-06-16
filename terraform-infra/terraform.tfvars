aws_region       = "ca-central-1"
environment      = "qa"
application_name = "cst"
owner            = "devops-team"

lambda_runtime = "python3.12"
lambda_handler = "app.lambda_handler"

lambda_zip_path = "../Lambda/test-function/app.zip"