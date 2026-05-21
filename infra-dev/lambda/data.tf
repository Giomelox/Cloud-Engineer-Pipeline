data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../lambda/ingestion"
  output_path = "../build/lambda.zip"
}