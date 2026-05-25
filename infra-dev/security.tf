# Criando um security group para as funções Lambda, permitindo apenas o tráfego de saída necessário para acessar outros serviços da AWS, como S3, DynamoDB, etc. 
# O tráfego de entrada é bloqueado por padrão, já que as funções Lambda não precisam receber conexões de entrada.
resource "aws_security_group" "ssg_lambda_dev_data_engineering" {
  vpc_id      = aws_vpc.vpc_dev_data_engineering.id
  name        = "ssg-lambda-dev-data-engineering"
  description = "Security group for lambda dev data engineering"


  tags = {
    Name  = "ssg-lambda-dev-data-engineering"
    owner = "dev-data-engineering"
  }

  egress {
    description = "Permitir-todo-trafego-de-saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*
Não será utilizado para o projeto, mas deixarei o código comentado para referência futura.
(Decisão tomada após analisar novamente a estrutura do meu projeto e sua finalidade.)

# Criar um security group para o RDS, permitindo apenas o tráfego de entrada na porta 5432 (PostgreSQL) a partir do security group das funções Lambda, 
# e bloqueando todo o tráfego de saída.
resource "aws_security_group" "ssg_rds_dev_data_engineering" {
  vpc_id      = aws_vpc.vpc_dev_data_engineering.id
  name        = "ssg-rds-dev-data-engineering"
  description = "Security group for RDS dev data engineering"


  tags = {
    Name  = "ssg-rds-dev-data-engineering"
    owner = "dev-data-engineering"
  }

  ingress {
    description     = "Permitir tráfego de entrada na porta 5432 a partir do security group das funções Lambda"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ssg_lambda_dev_data_engineering.id]
  }
}
*/

# Criar um security group para o Redshift, permitindo apenas o tráfego de entrada na porta 5439 (Redshift) a partir do security group das funções Lambda, 
# e bloqueando todo o tráfego de saída.
resource "aws_security_group" "ssg_redshift_dev_data_engineering" {
  vpc_id      = aws_vpc.vpc_dev_data_engineering.id
  name        = "ssg-redshift-dev-data-engineering"
  description = "Security group for Redshift dev data engineering"


  tags = {
    Name  = "ssg-redshift-dev-data-engineering"
    owner = "dev-data-engineering"
  }

  ingress {
    description     = "Permitir tráfego de entrada na porta 5439 a partir do security group das funções Lambda"
    from_port       = 5439
    to_port         = 5439
    protocol        = "tcp"
    security_groups = [aws_security_group.ssg_lambda_dev_data_engineering.id]
  }

}

# Criar um security group para os jobs do Glue, permitindo apenas o tráfego de entrada necessário para acessar os buckets S3 e outros recursos da AWS envolvidos 
# no processo de ETL, e bloqueando todo o tráfego de saída, já que os jobs do Glue não precisam iniciar conexões de saída.
resource "aws_security_group" "glue_job_security_group_dev_data_engineering" {
  vpc_id      = aws_vpc.vpc_dev_data_engineering.id
  name        = "glue-job-security-group-dev-data-engineering"
  description = "Security group for Glue job dev data engineering"

  tags = {
    Name  = "glue-job-security-group-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}