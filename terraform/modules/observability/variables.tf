variable "project_name" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "asg_name" {
  description = "Auto Scaling Group Name to monitor"
  type        = string
}

variable "alert_email" {
  description = "Email to receive alerts"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ARN Suffix of the ALB for Dashboard metrics"
  type        = string
}

variable "db_instance_id" {
  type = string
}

variable "cache_cluster_id" {
  type = string
}
