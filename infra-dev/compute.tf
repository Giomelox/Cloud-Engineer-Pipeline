#GLUE

module "lambda" {
  source = "./lambda"

  s3_bronze_bucket_name = aws_s3_bucket.bronze_bucket_dev_data_engineering.bucket
  s3_silver_bucket_name = aws_s3_bucket.silver_bucket_dev_data_engineering.bucket

  lambda_execution_role_arn = aws_iam_role.lambda_execution_role_dev_data_engineering.arn

  subnet_ids = [
    aws_subnet.private_subnet_dev_data_engineering_az1.id,
    aws_subnet.private_subnet_dev_data_engineering_az2.id
  ]

  security_group_ids = [
    aws_security_group.ssg_lambda_dev_data_engineering.id
  ]
}

module "glue_jobs" {

  source = "./glue"

  crawler_role_arn      = aws_iam_role.glue_crawler_role_dev_data_engineering.arn

  s3_gold_bucket_name      = aws_s3_bucket.gold_bucket_dev_data_engineering.bucket
  s3_bronze_bucket_name = aws_s3_bucket.bronze_bucket_dev_data_engineering.bucket
  s3_silver_bucket_name = aws_s3_bucket.silver_bucket_dev_data_engineering.bucket

  jobs = {
    silver_job = {
      name            = "glue-silver-job-dev-data-engineering"
      
      script_path     = "s3://${aws_s3_bucket.glue_bucket_dev_data_engineering.bucket}/scripts/process_to_silver_layer.py"
      dependencies_path = "s3://${aws_s3_bucket.glue_bucket_dev_data_engineering.bucket}/dependencies/dependencies.zip"

      worker_type     = "G.2X"
      number_workers  = 2

      role_arn        = aws_iam_role.glue_silver_job_role_dev_data_engineering.arn

      source_bucket   = "bronze"
      target_bucket   = "silver"
    },

    gold_job = {
      name            = "glue-gold-job-dev-data-engineering"

      script_path     = "s3://${aws_s3_bucket.glue_bucket_dev_data_engineering.bucket}/scripts/process_to_gold_layer.py"
      dependencies_path = "s3://${aws_s3_bucket.glue_bucket_dev_data_engineering.bucket}/dependencies/dependencies.zip"

      worker_type     = "G.2X"
      number_workers  = 2

      role_arn        = aws_iam_role.glue_gold_job_role_dev_data_engineering.arn

      source_bucket   = "bronze"
      target_bucket   = "gold"
    }
  }
  
}