resource "aws_glue_catalog_database" "glue_catalog_database_dev_data_engineering" {
  name = "glue-catalog-database-dev-data-engineering"
  description = "Glue Catalog Database para o projeto de engenharia de dados"

  tags = {
    Name  = "glue-catalog-database-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}