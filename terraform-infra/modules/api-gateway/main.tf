resource "aws_apigatewayv2_api" "this" {
  name          = var.api_name
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = var.allow_origins
    allow_methods = [
      "GET",
      "POST",
      "PUT",
      "DELETE",
      "OPTIONS"
    ]
    allow_headers = ["*"]
    expose_headers = ["*"]
    max_age        = 300
  }
  tags = merge(
    var.tags,
    {
      Name = var.api_name
    }
  )
}
resource "aws_apigatewayv2_vpc_link" "this" {
  name               = "${var.api_name}-vpc-link"
  subnet_ids         = var.private_subnet_ids
  security_group_ids = [var.vpc_link_sg_id]
}
resource "aws_apigatewayv2_integration" "this" {
  api_id = aws_apigatewayv2_api.this.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type = "VPC_LINK"
  connection_id   = aws_apigatewayv2_vpc_link.this.id
  integration_uri = var.alb_listener_arn
  payload_format_version = "1.0"
}
resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.this.id}"
}
resource "aws_apigatewayv2_route" "root" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /"
  target = "integrations/${aws_apigatewayv2_integration.this.id}"
}
resource "aws_apigatewayv2_stage" "this" {
  api_id = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}