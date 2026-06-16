data "archive_file" "lambda_zip" {

  type = "zip"

  source_dir = "${path.module}/../../../Lambda/test-function"

  output_path = "${path.module}/../../../Lambda/test-function/app.zip" 
}

resource "aws_lambda_function" "lambda" {

  function_name = var.lambda_name

  filename = data.archive_file.lambda_zip.output_path

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role = var.role_arn

  runtime = var.runtime

  handler = var.handler

  timeout     = 30
  memory_size = 256

  tags = var.tags
}