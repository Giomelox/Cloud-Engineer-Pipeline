output "api_url" {
  value = aws_api_gateway_stage.data_engineering_api_stage.invoke_url
}

output "api_key" {
  value = aws_api_gateway_api_key.data_engineering_api_key.value
}