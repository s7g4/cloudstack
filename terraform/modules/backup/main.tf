resource "aws_backup_vault" "main" {
  name = "${var.project_name}-backup-vault"
}

resource "aws_backup_plan" "main" {
  name = "${var.project_name}-backup-plan"

  rule {
    rule_name         = "DailyBackups"
    target_vault_name = aws_backup_vault.main.name
    schedule          = "cron(0 12 * * ? *)"

    lifecycle {
      delete_after = 30
    }
    
    # In a real multi-region setup, you would add a copy_action here
    # However, this requires a vault in the destination region which usually 
    # involves a separate terraform provider.
  }
}

resource "aws_iam_role" "backup_role" {
  name = "${var.project_name}-backup-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "backup.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "backup_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

resource "aws_backup_selection" "rds_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "${var.project_name}-rds-backup-selection"
  plan_id      = aws_backup_plan.main.id

  resources = [
    var.rds_instance_arn
  ]
}
