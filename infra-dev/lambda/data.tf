data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir = "${path.module}/../lambda/ingestion"
  output_path = "${path.module}/../lambda/ingestion/ingestion.zip"
}