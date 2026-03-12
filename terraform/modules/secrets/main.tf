resource "aws_secretsmanager_secret" "db_credentials" {
  name       = "${var.project_name}-db-password"
  kms_key_id = var.kms_key_arn

  tags = {
    Name = "${var.project_name}-db-password"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = var.db_password
}
