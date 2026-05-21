/*

 IAM necessários: 
 
 Glue Silver - Precisa de acesso de leitura ao bucket S3 onde os scripts e dependências estão armazenados, acesso e leitura ao bucket S3 Bronze,
 acesso de escrita ao bucket S3 Silver.

 Glue Gold - Precisa de acesso de leitura ao bucket S3 onde os scripts e dependências estão armazenados, acesso e leitura ao bucket S3 Silver,
 acesso de escrita ao bucket S3 Gold, acesso para escrever no data catalog

 Lambda - Precisa de acesso de escrita ao bucket S3 bronze, onde os dados ficarão armazenados os dados extraídos via API.

 Step Functions - Precisa de permissão para iniciar os jobs do Glue e invocar as funções Lambda.

*/

# =============================================================
# IAM ROLES E POLICIES PARA O GLUE JOBS SILVER
# =============================================================
resource "aws_iam_role" "glue_silver_job_role_dev_data_engineering" {
  name = "glue-silver-job-role-dev-data-engineering"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name  = "glue-silver-job-role-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}

resource "aws_iam_role_policy" "glue_silver_policy" {
  role = aws_iam_role.glue_silver_job_role_dev_data_engineering.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.glue_bucket_dev_data_engineering.arn,
          "${aws_s3_bucket.glue_bucket_dev_data_engineering.arn}/*",
          aws_s3_bucket.bronze_bucket_dev_data_engineering.arn,
          "${aws_s3_bucket.bronze_bucket_dev_data_engineering.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.silver_bucket_dev_data_engineering.arn,
          "${aws_s3_bucket.silver_bucket_dev_data_engineering.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# =============================================================
# IAM ROLES E POLICIES PARA O GLUE JOBS GOLD
# =============================================================

resource "aws_iam_role" "glue_gold_job_role_dev_data_engineering" {
  name = "glue-gold-job-role-dev-data-engineering"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name  = "glue-gold-job-role-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}

resource "aws_iam_role_policy" "glue_gold_policy" {
  role = aws_iam_role.glue_gold_job_role_dev_data_engineering.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.glue_bucket_dev_data_engineering.arn,
          "${aws_s3_bucket.glue_bucket_dev_data_engineering.arn}/*",
          aws_s3_bucket.silver_bucket_dev_data_engineering.arn,
          "${aws_s3_bucket.silver_bucket_dev_data_engineering.arn}/*"
        ]
      },

      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.gold_bucket_dev_data_engineering.arn,
          "${aws_s3_bucket.gold_bucket_dev_data_engineering.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# =============================================================
# IAM ROLES E POLICIES PARA O LAMBDA
# =============================================================

resource "aws_iam_role" "lambda_execution_role_dev_data_engineering" {
  name = "lambda-execution-role-dev-data-engineering"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name  = "lambda-execution-role-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}

resource "aws_iam_role_policy" "lambda_execution_policy" {
  role = aws_iam_role.lambda_execution_role_dev_data_engineering.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.bronze_bucket_dev_data_engineering.arn,
          "${aws_s3_bucket.bronze_bucket_dev_data_engineering.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# =============================================================
# IAM ROLES E POLICIES PARA O GLUE CRAWLER
# =============================================================

resource "aws_iam_role" "glue_crawler_role_dev_data_engineering" {
  name = "glue-crawler-role-dev-data-engineering"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name  = "glue-crawler-role-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}

resource "aws_iam_role_policy" "glue_crawler_policy" {
  role = aws_iam_role.glue_crawler_role_dev_data_engineering.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.gold_bucket_dev_data_engineering.arn,
          "${aws_s3_bucket.gold_bucket_dev_data_engineering.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:GetTable",
          "glue:GetTableVersion",
          "glue:GetTableVersions",
          "glue:GetDatabase",
          "glue:GetDatabase",
          "glue:CreatePartition",
          "glue:UpdatePartition",
          "glue:GetPartition"
        ]
        Resource = [
          "arn:aws:glue:${var.region}:${var.account_id}:catalog",
          "arn:aws:glue:${var.region}:${var.account_id}:database/gold",
          "arn:aws:glue:${var.region}:${var.account_id}:table/gold/*"
        ]
      },
      
    ]
  })
}

# =============================================================
# IAM ROLES E POLICIES PARA O STEP FUNCTIONS
# =============================================================

resource "aws_iam_role" "step_functions_role_dev_data_engineering" {
  name = "step-functions-role-dev-data-engineering"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name  = "step-functions-role-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}

resource "aws_iam_role_policy" "step_functions_policy" {
  role = aws_iam_role.step_functions_role_dev_data_engineering.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "glue:GetJobRun",
          "glue:GetJobRuns",
          "glue:StartJobRun",
        ]
        Resource = [
          aws_glue_job.this["silver_job"].arn,
          aws_glue_job.this["gold_job"].arn
        ]
      },

      {
        Effect = "Allow"
        Action = [
          "glue:StartCrawler"
        ]
        Resource = [
          aws_glue_crawler.dev_data_engineering_crawler.arn
        ]
      },

      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = [
          module.lambda.lambda_arn
        ]
      }
    ]
  })
}

# =============================================================
# IAM ROLES E POLICIES PARA O EVENTBRIDGE
# =============================================================

resource "aws_iam_role" "eventbridge_role" {
  name = "eventbridge-start-stepfunctions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "events.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name  = "eventbridge-start-stepfunctions"
    owner = "dev-data-engineering"
  }
}

resource "aws_iam_role_policy" "eventbridge_policy" {
  role = aws_iam_role.eventbridge_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "states:StartExecution"
      ]
      Resource = [
        aws_sfn_state_machine.state_machine_dev_data_engineering.arn
      ]
    }]
  })
}