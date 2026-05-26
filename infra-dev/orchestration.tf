# Step Funcions - Orquestração dos pipeline após acionamento do EventBridge.
resource "aws_sfn_state_machine" "state_machine_dev_data_engineering" {
  name     = "state-machine-dev-data-engineering"
  role_arn = aws_iam_role.step_functions_role_dev_data_engineering.arn

  type = "STANDARD"

  definition = templatefile("${path.module}/step_functions_definitions/step_function_definition.json", {
    lambda_arn   = module.lambda.lambda_arn
    silver_job   = module.glue_jobs.silver_job_name
    gold_job     = module.glue_jobs.gold_job_name
    crawler_name = module.glue_jobs.crawler_name
  })

  tags = {
    Name  = "state-machine-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}