resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
// Dynamic Engress
resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = {
    for idx, rule in var.ingress_rules :
    idx => rule
  }
  security_group_id = aws_security_group.this.id
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  referenced_security_group_id = try(each.value.source_sg_id, null)
}
// Dynamic Egress
resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = {
    for idx, rule in var.egress_rules :
    idx => rule
  }
  security_group_id = aws_security_group.this.id
  ip_protocol = each.value.protocol
  from_port = each.value.protocol == "-1" ? null : each.value.from_port
  to_port   = each.value.protocol == "-1" ? null : each.value.to_port
  cidr_ipv4 = each.value.cidr
}