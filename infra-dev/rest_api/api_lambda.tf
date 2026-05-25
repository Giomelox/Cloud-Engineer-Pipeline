/* 
Esta API não será um módulo pois só será utilizada para criar as funções Lambda, e não há necessidade de reutilização em outros contextos.

aws_api_gateway_rest_api        → cria a API em si
aws_api_gateway_resource        → define o path (/summoner, por exemplo)
aws_api_gateway_method          → define o método HTTP (GET, POST)
aws_api_gateway_integration     → conecta o método ao Lambda
aws_api_gateway_deployment      → faz o deploy da API
aws_api_gateway_stage           → define o estágio (dev, prod)
aws_lambda_permission           → permite o API Gateway invocar o Lambda

aws_api_gateway_api_key         → cria uma chave de API para controle de acesso
aws_api_gateway_usage_plan      → define as regras de limitação e cota para a chave
aws_api_gateway_usage_plan_key  → associa a chave de API ao plano de uso
*/

# Criando a API Gateway para o projeto de engenharia de dados, com um recurso e método para invocar as funções Lambda.
resource "aws_api_gateway_rest_api" "data_engineering_api" {
  name        = "DataEngineeringAPI"
  description = "API Gateway para o projeto de engenharia de dados"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  minimum_compression_size = 1024

  tags = {
    Name  = "DataEngineeringAPI"
    owner = "dev-data-engineering"
  }
}

# Criando um recurso para a API Gateway, que será utilizado para invocar as funções Lambda.
resource "aws_api_gateway_resource" "summoner_resource_dev_data_engineering" {
  rest_api_id = aws_api_gateway_rest_api.data_engineering_api.id
  parent_id   = aws_api_gateway_rest_api.data_engineering_api.root_resource_id
  path_part   = "{name}"
}

# Criando um método GET para o recurso criado, que exigirá uma chave de API para acesso.
resource "aws_api_gateway_method" "summoner_method_dev_data_engineering" {
  rest_api_id   = aws_api_gateway_rest_api.data_engineering_api.id
  resource_id   = aws_api_gateway_resource.summoner_resource_dev_data_engineering.id
  http_method   = "GET"
  authorization = "NONE"

  api_key_required = true

  request_parameters = {
    "method.request.path.name" = true
  }
}

# Criando a integração entre o método GET e a função Lambda, utilizando o tipo AWS_PROXY para permitir a passagem de toda a requisição para o Lambda.
resource "aws_api_gateway_integration" "summoner_integration_dev_data_engineering" {
  rest_api_id             = aws_api_gateway_rest_api.data_engineering_api.id
  resource_id             = aws_api_gateway_resource.summoner_resource_dev_data_engineering.id
  http_method             = aws_api_gateway_method.summoner_method_dev_data_engineering.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# Criando a permissão para que o API Gateway possa invocar a função Lambda.
resource "aws_lambda_permission" "api_gateway_permission_dev_data_engineering" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.data_engineering_api.execution_arn}/*/*"

  source_account = var.account_id
}

# Criando a implantação da API Gateway, que será utilizada para criar um estágio e disponibilizar a API para acesso.
resource "aws_api_gateway_deployment" "data_engineering_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.data_engineering_api.id

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.summoner_resource_dev_data_engineering.id,
      aws_api_gateway_method.summoner_method_dev_data_engineering.id,
      aws_api_gateway_integration.summoner_integration_dev_data_engineering.id
    ]))
  }

  depends_on = [aws_api_gateway_integration.summoner_integration_dev_data_engineering]
}

# Criando um estágio para a API Gateway, que será utilizado para disponibilizar a API para acesso.
resource "aws_api_gateway_stage" "data_engineering_api_stage" {
  stage_name    = "dev"
  rest_api_id   = aws_api_gateway_rest_api.data_engineering_api.id
  deployment_id = aws_api_gateway_deployment.data_engineering_api_deployment.id

  xray_tracing_enabled = true

  tags = {
    Name  = "DataEngineeringAPIStage"
    owner = "dev-data-engineering"
  }
}

# Criando uma chave de API para a API Gateway, que será utilizada para controlar o acesso à API.
resource "aws_api_gateway_api_key" "data_engineering_api_key" {
  name      = "DataEngineeringAPIKey"
  enabled   = true

  tags = {
    Name  = "DataEngineeringAPIKey"
    owner = "dev-data-engineering"
  }
}

# Criando um plano de uso para a API Gateway, que será utilizado para definir as regras de limitação e cota para as requisições que utilizarem a chave de API.
resource "aws_api_gateway_usage_plan" "data_engineering_api_usage_plan" {
  name = "DataEngineeringAPIUsagePlan"

  api_stages {
    api_id = aws_api_gateway_rest_api.data_engineering_api.id
    stage   = aws_api_gateway_stage.data_engineering_api_stage.stage_name
  }

  throttle_settings {
    rate_limit  = 10 # Requisições por segundo
    burst_limit = 5 # Pico máximo de requisições em um curto período
  }

  quota_settings {
    limit  = 20 # Limite diário de requisições
    period = "DAY"
  }

   tags = {
    Name  = "DataEngineeringAPIUsagePlan"
    owner = "dev-data-engineering"
  }
}

# Associando a chave de API ao plano de uso, para que as regras de limitação e cota sejam aplicadas às requisições que utilizarem essa chave.
resource "aws_api_gateway_usage_plan_key" "data_engineering_api_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.data_engineering_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.data_engineering_api_usage_plan.id
}