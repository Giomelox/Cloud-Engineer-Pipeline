output "silver_job_name" {
  value = aws_glue_job.this["silver_job"].name
}

output "gold_job_name" {
  value = aws_glue_job.this["gold_job"].name
}

output "silver_job_arn" {
  value = aws_glue_job.this["silver_job"].arn
}

output "gold_job_arn" {
  value = aws_glue_job.this["gold_job"].arn
}

output "crawler_name" {
  value = aws_glue_crawler.dev_data_engineering_crawler.name
}

output "silver_job_name" {
  value = aws_glue_job.this["silver_job"].name
}

output "gold_job_name" {
  value = aws_glue_job.this["gold_job"].name
}