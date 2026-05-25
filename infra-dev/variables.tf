variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS CLI profile to use for authentication"
  type        = string
}

/*
variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
}
*/

variable "redshift_password" {
  description = "Password for the Redshift cluster"
  type        = string
  sensitive   = true
}

variable "riot_api_key" {
  description = "Riot Games API Key"
  type        = string
  sensitive   = true
}