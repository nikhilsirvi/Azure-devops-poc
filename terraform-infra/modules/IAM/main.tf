data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = [var.service_principal]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "this" {
  name = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = merge(
    var.tags,
    {
      Name = var.role_name
    }
  )
}
resource "aws_iam_role_policy_attachment" "this" {
  count = length(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = var.managed_policy_arns[count.index]
}