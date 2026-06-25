resource "aws_ssm_parameter" "this" {
  name  = var.name
  type  = var.type
  value = var.value
  tier = var.tier
  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}