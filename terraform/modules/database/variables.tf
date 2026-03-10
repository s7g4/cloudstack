variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "app_sg_id" {
  description = "Security Group ID of the Application (ASG) to allow access"
  type        = string
}

variable "db_password" {
  description = "Database Master Password"
  type        = string
  sensitive   = true
}

variable "kms_key_arn" {
  description = "KMS Key ARN for encryption"
  type        = string
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}
