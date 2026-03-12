variable "project_name" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
