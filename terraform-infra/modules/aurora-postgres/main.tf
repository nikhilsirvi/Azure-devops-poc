resource "aws_rds_cluster" "this" {
  cluster_identifier = var.cluster_identifier
  engine         = "aurora-postgresql"
  engine_version = var.engine_version
  database_name   = var.database_name
  master_username = var.master_username
  master_password = var.master_password
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  backup_retention_period = var.backup_retention_period
  storage_encrypted  = true
  deletion_protection = var.deletion_protection
  serverlessv2_scaling_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }
  skip_final_snapshot = true
  tags = merge(
    var.tags,
    {
      Name = var.cluster_identifier
    }
  )
}
resource "aws_rds_cluster_instance" "writer" {
  identifier         = "${var.cluster_identifier}-writer"
  cluster_identifier = aws_rds_cluster.this.id
  engine         = aws_rds_cluster.this.engine
  engine_version = aws_rds_cluster.this.engine_version
  instance_class = "db.serverless"
  publicly_accessible = var.publicly_accessible
  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_identifier}-writer"
    }
  )
}