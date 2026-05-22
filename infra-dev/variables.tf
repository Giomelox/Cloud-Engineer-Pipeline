variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "redshift_password" {
  description = "Password for the Redshift cluster"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}