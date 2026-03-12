output "cache_endpoint" {
  value = aws_elasticache_cluster.main.cache_nodes[0].address
}

output "cache_sg_id" {
  value = aws_security_group.cache_sg.id
}
