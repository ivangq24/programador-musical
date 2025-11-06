# Secrets Manager for application secrets
resource "aws_secretsmanager_secret" "app_secrets" {
  name        = "${local.name_prefix}-app-secrets"
  description = "Application secrets for ${var.project_name}"
  
  # Enable automatic rotation (optional)
  # rotation_lambda_arn = aws_lambda_function.rotation.arn
  # rotation_rules {
  #   automatically_after_days = 30
  # }

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "app_secrets" {
  secret_id = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode({
    jwt_secret_key        = var.jwt_secret_key
    database_url          = "postgresql://${var.database_username}:${var.database_password}@${aws_db_instance.main.endpoint}/${var.database_name}"
    database_host         = aws_db_instance.main.endpoint
    database_name         = var.database_name
    database_username     = var.database_username
    database_password     = var.database_password
    cognito_user_pool_id  = aws_cognito_user_pool.main.id
    cognito_client_id     = aws_cognito_user_pool_client.web.id
    cognito_region        = var.aws_region
  })
}

# Database credentials secret (separate for RDS integration)
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${local.name_prefix}-db-credentials"
  description = "Database credentials for RDS instance"

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.database_username
    password = var.database_password
    engine   = "postgres"
    host     = aws_db_instance.main.endpoint
    port     = aws_db_instance.main.port
    dbname   = var.database_name
  })
}