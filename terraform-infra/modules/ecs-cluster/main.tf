resource "aws_ecs_cluster" "this" {
  name = var.name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}