output "lambda_arn" {
  value = aws_lambda_function.lambda_dev_data_engineering.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.lambda_dev_data_engineering.invoke_arn
}