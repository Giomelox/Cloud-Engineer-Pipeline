variable "jobs" {
  type = map(object({
    name            = string
    script_path     = string
    worker_type     = string
    number_workers  = number
    role_arn        = string
    dependencies_path = string
  }))
}

variable "s3_bronze_bucket_name" {
  type = string
}

variable "s3_silver_bucket_name" {
  type = string
}

variable "s3_gold_bucket_name" {
  type = string
}

variable "crawler_role_arn" {
  type = string
}