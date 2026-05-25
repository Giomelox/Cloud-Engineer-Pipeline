resource "aws_secretsmanager_secret" "data_engineering_api_secret" {
  name        = "DataEngineeringAPISecret"
  description = "Secret for Data Engineering API"

  tags = {
    Name  = "DataEngineeringAPISecret"
    owner = "dev-data-engineering"
  }
}

resource "aws_secretsmanager_secret_version" "data_engineering_api_secret_version" {
  secret_id     = aws_secretsmanager_secret.data_engineering_api_secret.id
  secret_string = jsonencode({
    api_key = aws_api_gateway_api_key.data_engineering_api_key.value
  })
}