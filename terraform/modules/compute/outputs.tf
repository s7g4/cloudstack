output "asg_name" {
  value = aws_autoscaling_group.web.name
}

output "alb_dns_name" {
  value = aws_lb.web.dns_name
}

output "alb_arn_suffix" {
  value = aws_lb.web.arn_suffix
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "alb_arn" {
  value = aws_lb.web.arn
}
