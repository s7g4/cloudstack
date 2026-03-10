resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow inbound traffic from Web/App SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from ASG"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "14"
  instance_class          = var.instance_class
  db_name                 = "cloudstack_db"
  username                = "dbadmin"
  password                = var.db_password # In production, use AWS Secrets Manager!
  parameter_group_name    = "default.postgres14"
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  multi_az                = var.multi_az
  storage_encrypted       = true
  kms_key_id              = var.kms_key_arn
  backup_retention_period = 7
  skip_final_snapshot     = true # Usually false in prod, but keeping true for demo teardown ease
  deletion_protection     = false # Usually true in prod

  tags = {
    Name = "${var.project_name}-rds"
  }
}
