# RDS Instance
resource "aws_db_instance" "main" {
  identifier = "${local.name_prefix}-db"

  # Engine configuration
  engine         = "postgres"
  engine_version = "15.7"  # Updated to available version
  instance_class = var.db_instance_class

  # Database configuration
  db_name  = var.database_name
  username = var.database_username
  password = var.database_password

  # Storage configuration
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  # Backup configuration (minimal for cost savings)
  backup_retention_period = 1  # Reduced to minimum
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  # Monitoring (disabled for cost savings)
  monitoring_interval = 0  # Disable enhanced monitoring
  # monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  # Performance Insights (disabled for cost savings)
  performance_insights_enabled = false

  # Deletion protection
  deletion_protection = var.enable_deletion_protection
  skip_final_snapshot = !var.enable_deletion_protection

  # Final snapshot identifier (only if deletion protection is enabled)
  final_snapshot_identifier = var.enable_deletion_protection ? "${local.name_prefix}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}" : null

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db"
  })
}

# RDS Monitoring Role (commented out for cost savings)
# resource "aws_iam_role" "rds_monitoring" {
#   name = "${local.name_prefix}-rds-monitoring-role"
# 
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "monitoring.rds.amazonaws.com"
#         }
#       }
#     ]
#   })
# 
#   tags = local.common_tags
# }
# 
# resource "aws_iam_role_policy_attachment" "rds_monitoring" {
#   role       = aws_iam_role.rds_monitoring.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
# }