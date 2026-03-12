variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "cloudstack-demo"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private Subnet CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "ec2_instance_type" {
  default = "t3.micro"
}

variable "asg_min_size" {
  default = 2
}

variable "asg_max_size" {
  default = 4
}

variable "db_password" {
  description = "Production DB Password"
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "Email address to receive CloudWatch alarm notifications"
  type        = string
  default     = "ops-team@example.com"
}
