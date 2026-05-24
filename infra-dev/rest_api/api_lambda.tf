/* 
Esta API não será um módulo pois só será utilizada para criar as funções Lambda, e não há necessidade de reutilização em outros contextos.

aws_api_gateway_rest_api        → cria a API em si
aws_api_gateway_resource        → define o path (/summoner, por exemplo)
aws_api_gateway_method          → define o método HTTP (GET, POST)
aws_api_gateway_integration     → conecta o método ao Lambda
aws_api_gateway_deployment      → faz o deploy da API
aws_api_gateway_stage           → define o estágio (dev, prod)
aws_lambda_permission           → permite o API Gateway invocar o Lambda
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

resource "aws_api_gateway_method" "summoner_method_dev_data_engineering" {
  rest_api_id   = aws_api_gateway_rest_api.data_engineering_api.id
  resource_id   = aws_api_gateway_resource.summoner_resource_dev_data_engineering.id
  http_method   = "GET"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "summoner_integration_dev_data_engineering" {
  rest_api_id             = aws_api_gateway_rest_api.data_engineering_api.id
  resource_id             = aws_api_gateway_resource.summoner_resource_dev_data_engineering.id
  http_method             = aws_api_gateway_method.summoner_method_dev_data_engineering.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda.lambda_invoke_arn
}

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

resource "aws_lambda_permission" "api_gateway_permission_dev_data_engineering" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.data_engineering_api.execution_arn}/dev/GET/summoner"

  source_account = var.account_id
}