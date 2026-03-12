output "web_alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = module.compute.alb_dns_name
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = module.cloudfront.distribution_domain_name
}

output "rds_endpoint" {
  description = "Endpoint for the RDS database"
  value       = module.database.db_instance_endpoint
}

output "elasticache_primary_endpoint" {
  description = "Primary endpoint for the ElastiCache cluster"
  value       = module.cache.primary_endpoint
}

output "kms_key_arn" {
  description = "ARN of the KMS key"
  value       = module.kms.key_arn
}
