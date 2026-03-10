output "db_endpoint" {
  value = aws_db_instance.default.endpoint
}

output "db_instance_id" {
  value = aws_db_instance.default.id
}

output "db_instance_arn" {
  value = aws_db_instance.default.arn
}
