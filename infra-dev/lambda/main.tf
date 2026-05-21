resource "aws_lambda_function" "lambda_dev_data_engineering" {
  function_name = "lambda-dev-data-engineering"

  role = var.lambda_execution_role_arn

  handler = "main.lambda_handler"
  runtime = "python3.13"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  # Variáveis de ambiente para a função Lambda, permitindo a configuração dinâmica de parâmetros como o nome do bucket S3 e a chave do objeto, 
  # facilitando a reutilização da função para diferentes cenários e ambientes.
  environment {
    variables = {
      S3_BRONZE_BUCKET = var.s3_bronze_bucket_name
      S3_SILVER_BUCKET = var.s3_silver_bucket_name
    }
  }

  tags = {
    Name  = "lambda-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}