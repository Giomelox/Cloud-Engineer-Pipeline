variable "s3_bronze_bucket_name" {
  type = string
}

variable "s3_silver_bucket_name" {
  type = string
}

variable "lambda_execution_role_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "state_machine_arn" {
  type = string
}