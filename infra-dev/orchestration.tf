# EventBridge - Acionamento do pipeline diariamente às 06:00 AM.
resource "aws_cloudwatch_event_rule" "daily_pipeline_data_engineering" {
  name                = "daily-data-pipeline"
  description         = "Executa o pipeline diariamente"

  schedule_expression = "cron(0 6 * * ? *)"
  
  tags = {
    Name  = "daily-data-pipeline"
    owner = "dev-data-engineering"
  }
}

resource "aws_cloudwatch_event_target" "step_function_target_data_engineering" {
  rule     = aws_cloudwatch_event_rule.daily_pipeline_data_engineering.name
  arn      = aws_sfn_state_machine.state_machine_dev_data_engineering.arn
  role_arn = aws_iam_role.eventbridge_role.arn
}

# Step Funcions - Orquestração dos pipeline após acionamento do EventBridge.
resource "aws_sfn_state_machine" "state_machine_dev_data_engineering" {
  name     = "state-machine-dev-data-engineering"
  role_arn = aws_iam_role.step_functions_role_dev_data_engineering.arn

  type       = "STANDARD"

  definition = templatefile("${path.module}/steps_functions_definitions/step_function_definition.json", {
    lambda_arn  = module.lambda.lambda_arn
    silver_job  = module.glue_jobs.silver_job_name
    gold_job    = module.glue_jobs.gold_job_name
    crawler_name = module.glue_jobs.crawler_name
  })

  tags = {
    Name  = "state-machine-dev-data-engineering"
    owner = "dev-data-engineering"
   }
}