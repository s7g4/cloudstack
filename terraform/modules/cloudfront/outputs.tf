output "cf_domain_name" {
  value = aws_cloudfront_distribution.main.domain_name
}

output "cf_id" {
  value = aws_cloudfront_distribution.main.id
}
