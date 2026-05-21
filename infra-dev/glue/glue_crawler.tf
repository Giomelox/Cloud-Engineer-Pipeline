resource "aws_glue_crawler" "dev_data_engineering_crawler" {
  name          = "dev-data-engineering-crawler"
  role          = var.crawler_role_arn
  database_name = aws_glue_catalog_database.glue_catalog_database_dev_data_engineering.name 

  s3_target {
    path = "s3://${var.s3_gold_bucket_name}/"
  }

  tags = {
    Name  = "dev-data-engineering-crawler"
    owner = "dev-data-engineering"
  }
}