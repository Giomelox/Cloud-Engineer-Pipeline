# Criando um job do AWS Glue para processar os dados e movê-los da camada silver para a camada gold, 
# utilizando um script Python armazenado no bucket S3 criado anteriormente. 
# O job será configurado para usar um papel do IAM que permita o acesso necessário aos recursos envolvidos no processo de ETL.
resource "aws_glue_job" "this" {
  for_each = var.jobs

  name     = each.value.name
  role_arn = each.value.role_arn

  max_retries       = 0
  timeout           = 30
  glue_version      = "5.0"
  number_of_workers = each.value.number_workers
  worker_type       = each.value.worker_type

  command {
    name            = "glueetl"
    script_location = each.value.script_path
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"   = "python"
    
    "--extra-py-files" = each.value.dependencies_path

    "--SOURCE_BUCKET" = each.value.source_bucket
    "--TARGET_BUCKET" = each.value.target_bucket
  }

  tags = {
    Name  = each.value.name
    owner = "dev-data-engineering"
  }
}