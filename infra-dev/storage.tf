# Criando um bucket S3 para armazenar dados e arquivos relacionados ao projeto de engenharia de dados.
# com uma política de acesso que permita apenas o acesso necessário para as funções Lambda e outros serviços da AWS envolvidos no projeto.
resource "aws_s3_bucket" "glue_bucket_dev_data_engineering" {
  bucket = "glue-bucket-dev-data-engineering"

  tags = {
    Name  = "glue-bucket-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}

resource "aws_s3_bucket_versioning" "glue_bucket_versioning_dev_data_engineering" {
  bucket = aws_s3_bucket.glue_bucket_dev_data_engineering.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "glue_bucket_public_access_block_dev_data_engineering" {
  bucket = aws_s3_bucket.glue_bucket_dev_data_engineering.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "glue_bucket_server_side_encryption_configuration_dev_data_engineering" {
  bucket = aws_s3_bucket.glue_bucket_dev_data_engineering.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Criando um bucket S3 para armazenar dados e arquivos relacionados ao projeto de engenharia de dados, 
# com uma política de acesso que permita apenas o acesso necessário para as funções Lambda e outros serviços da AWS envolvidos no projeto.

# ============================================================
# BRONZE BUCKET
# ============================================================
resource "aws_s3_bucket" "bronze_bucket_dev_data_engineering" {
  bucket = "bronze-bucket-dev-data-engineering"

  tags = {
    Name  = "bronze-bucket-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}

resource "aws_s3_bucket_versioning" "bronze_versioning" {
  bucket = aws_s3_bucket.bronze_bucket_dev_data_engineering.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bronze_bucket_server_side_encryption_configuration_dev_data_engineering" {
  bucket = aws_s3_bucket.bronze_bucket_dev_data_engineering.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Encriptografia do lado do servidor para o bucket gold, garantindo que os dados armazenados estejam protegidos e seguros, utilizando o algoritmo AES256 para criptografia.
resource "aws_s3_bucket_public_access_block" "bronze_bucket_public_access_block_dev_data_engineering" {
  bucket = aws_s3_bucket.bronze_bucket_dev_data_engineering.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ============================================================
# SILVER BUCKET
# ============================================================
resource "aws_s3_bucket" "silver_bucket_dev_data_engineering" {
  bucket = "silver-bucket-dev-data-engineering"

  tags = {
    Name  = "silver-bucket-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}

resource "aws_s3_bucket_versioning" "silver_versioning" {
  bucket = aws_s3_bucket.silver_bucket_dev_data_engineering.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "silver_bucket_public_access_block_dev_data_engineering" {
  bucket = aws_s3_bucket.silver_bucket_dev_data_engineering.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Encriptografia do lado do servidor para o bucket gold, garantindo que os dados armazenados estejam protegidos e seguros, utilizando o algoritmo AES256 para criptografia.
resource "aws_s3_bucket_server_side_encryption_configuration" "silver_bucket_server_side_encryption_configuration_dev_data_engineering" {
  bucket = aws_s3_bucket.silver_bucket_dev_data_engineering.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# ============================================================
# GOLD BUCKET
# ============================================================
resource "aws_s3_bucket" "gold_bucket_dev_data_engineering" {
  bucket = "gold-bucket-dev-data-engineering"

  tags = {
    Name  = "gold-bucket-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}

resource "aws_s3_bucket_versioning" "gold_versioning" {
  bucket = aws_s3_bucket.gold_bucket_dev_data_engineering.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "gold_bucket_public_access_block_dev_data_engineering" {
  bucket = aws_s3_bucket.gold_bucket_dev_data_engineering.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Encriptografia do lado do servidor para o bucket gold, garantindo que os dados armazenados estejam protegidos e seguros, utilizando o algoritmo AES256 para criptografia.
resource "aws_s3_bucket_server_side_encryption_configuration" "gold_bucket_server_side_encryption_configuration_dev_data_engineering" {
  bucket = aws_s3_bucket.gold_bucket_dev_data_engineering.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
# ============================================================
# ============================================================

/*
Não será utilizado para o projeto, mas deixarei o código comentado para referência futura. 
(Decisão tomada após analisar novamente a estrutura do meu projeto e sua finalidade.)

# Criando um RDS PostgreSQL para armazenar dados estruturados, com configurações de segurança e rede adequadas para garantir a proteção dos dados 
# e o acesso controlado a partir das funções Lambda e outros serviços da AWS envolvidos no projeto.
resource "aws_db_instance" "rds_dev_data_engineering" {
  identifier = "rds-dev-data-engineering"

  allocated_storage = 10

  engine         = "postgres"
  engine_version = "16"
  instance_class = "db.t3.micro"

  deletion_protection = true

  username = "admin"
  password = var.db_password

  publicly_accessible    = false
  storage_encrypted      = true
  vpc_security_group_ids = [aws_security_group.ssg_rds_dev_data_engineering.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group_dev_data_engineering.name

  tags = {
    Name  = "rds-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}
*/

# Criando um cluster Redshift para análise de dados em larga escala, com configurações de segurança e rede adequadas para garantir a proteção dos dados 
# e o acesso controlado a partir das funções Lambda e outros serviços da AWS envolvidos no projeto.
resource "aws_redshift_cluster" "redshift_dev_data_engineering" {
  cluster_identifier = "redshift-dev-data-engineering"

  database_name   = "dev_data_engineering_db"
  master_username = "admin"
  master_password = var.redshift_password

  node_type    = "dc2.large"
  cluster_type = "single-node"

  encrypted = true

  skip_final_snapshot       = false
  final_snapshot_identifier = "redshift-dev-data-engineering-final"

  publicly_accessible       = false
  vpc_security_group_ids    = [aws_security_group.ssg_redshift_dev_data_engineering.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group_dev_data_engineering.name

  tags = {
    Name  = "redshift-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}