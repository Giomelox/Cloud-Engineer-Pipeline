resource "aws_vpc" "vpc_dev_data_engineering" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name  = "vpc-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}

# Sub-rede pública para hospedar recursos que precisam de acesso à internet, como o NAT Gateway.
resource "aws_subnet" "public_subnet_dev_data_engineering_az1" {
  vpc_id            = aws_vpc.vpc_dev_data_engineering.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name  = "public-subnet-dev-data-engineering-az1"
    owner = "dev-data-engineering"
  }
}

# Criar a sub-rede privada para os recursos que não precisam de acesso direto à internet, como bancos de dados e servidores de aplicação.
resource "aws_subnet" "private_subnet_dev_data_engineering_az1" {
  vpc_id            = aws_vpc.vpc_dev_data_engineering.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name  = "private-subnet-dev-data-engineering-az1"
    owner = "dev-data-engineering"
  }
}

resource "aws_subnet" "public_subnet_dev_data_engineering_az2" {
  vpc_id            = aws_vpc.vpc_dev_data_engineering.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name  = "public-subnet-dev-data-engineering-az2"
    owner = "dev-data-engineering"
  }
}

resource "aws_subnet" "private_subnet_dev_data_engineering_az2" {
  vpc_id            = aws_vpc.vpc_dev_data_engineering.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name  = "private-subnet-dev-data-engineering-az2"
    owner = "dev-data-engineering"
  }
}

# Internet gateway para a VPC e permitir a comunicação das subnets públicas com a internet.
resource "aws_internet_gateway" "igw_dev_data_engineering" {
  vpc_id = aws_vpc.vpc_dev_data_engineering.id

  tags = {
    Name  = "igw-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}

# Criação do elastic IP para o NAT Gateway da AZ1
resource "aws_eip" "nat_eip_dev_data_engineering_az1" {
  domain = "vpc"

  tags = {
    Name  = "nat-eip-dev-data-engineering-az1"
    owner = "dev-data-engineering"
  }
}

# Criação do elastic IP para o NAT Gateway da AZ2
resource "aws_eip" "nat_eip_dev_data_engineering_az2" {
  domain = "vpc"

  tags = {
    Name  = "nat-eip-dev-data-engineering-az2"
    owner = "dev-data-engineering"
  }
}

# Criação do NAT Gateway para permitir que as subnets privadas da AZ1 acessem a internet.
resource "aws_nat_gateway" "nat_gw_dev_data_engineering_az1" {
  allocation_id = aws_eip.nat_eip_dev_data_engineering_az1.id
  subnet_id     = aws_subnet.public_subnet_dev_data_engineering_az1.id

  tags = {
    Name  = "nat-gw-az1-dev-data-engineering"
    owner = "dev-data-engineering"
  }

  depends_on = [aws_internet_gateway.igw_dev_data_engineering]
}

# Criação do NAT Gateway para permitir que as subnets privadas da AZ2 acessem a internet.
resource "aws_nat_gateway" "nat_gw_dev_data_engineering_az2" {
  allocation_id = aws_eip.nat_eip_dev_data_engineering_az2.id
  subnet_id     = aws_subnet.public_subnet_dev_data_engineering_az2.id

  tags = {
    Name  = "nat-gw-az2-dev-data-engineering"
    owner = "dev-data-engineering"
  }

  depends_on = [aws_internet_gateway.igw_dev_data_engineering]
}

# ============================================================
# ROUTE TABLE PARA A SUB-REDE PÚBLICA - AZ1
# ============================================================

resource "aws_route_table" "public_route_table_dev_data_engineering_az1" {
  vpc_id = aws_vpc.vpc_dev_data_engineering.id

  tags = {
    Name  = "public-route-table-dev-data-engineering-az1"
    owner = "dev-data-engineering"
  }
}

resource "aws_route" "public_route_dev_data_engineering_az1" {
  route_table_id         = aws_route_table.public_route_table_dev_data_engineering_az1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_dev_data_engineering.id
}

resource "aws_route_table_association" "public_route_table_association_dev_data_engineering_az1" {
  subnet_id      = aws_subnet.public_subnet_dev_data_engineering_az1.id
  route_table_id = aws_route_table.public_route_table_dev_data_engineering_az1.id
}

# ============================================================
# ============================================================




# ============================================================
# ROUTE TABLE PARA A SUB-REDE PRIVADA - AZ1
# ============================================================

resource "aws_route_table" "private_route_table_dev_data_engineering_az1" {
  vpc_id = aws_vpc.vpc_dev_data_engineering.id

  tags = {
    Name  = "private-route-table-dev-data-engineering-az1"
    owner = "dev-data-engineering"
  }
}

resource "aws_route" "private_route_dev_data_engineering_az1" {
  route_table_id         = aws_route_table.private_route_table_dev_data_engineering_az1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_dev_data_engineering_az1.id
}

resource "aws_route_table_association" "private_route_table_association_dev_data_engineering_az1" {
  subnet_id      = aws_subnet.private_subnet_dev_data_engineering_az1.id
  route_table_id = aws_route_table.private_route_table_dev_data_engineering_az1.id
}

# ============================================================
# ============================================================



# ============================================================
# ROUTE TABLE PARA A SUB-REDE PÚBLICA - AZ2
# ============================================================

resource "aws_route_table" "public_route_table_dev_data_engineering_az2" {
  vpc_id = aws_vpc.vpc_dev_data_engineering.id

  tags = {
    Name  = "public-route-table-dev-data-engineering-az2"
    owner = "dev-data-engineering"
  }
}

resource "aws_route" "public_route_dev_data_engineering_az2" {
  route_table_id         = aws_route_table.public_route_table_dev_data_engineering_az2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_dev_data_engineering.id
}

resource "aws_route_table_association" "public_route_table_association_dev_data_engineering_az2" {
  subnet_id      = aws_subnet.public_subnet_dev_data_engineering_az2.id
  route_table_id = aws_route_table.public_route_table_dev_data_engineering_az2.id
}

# ============================================================
# ============================================================


# ============================================================
# ROUTE TABLE PARA A SUB-REDE PRIVADA - AZ2
# ============================================================

resource "aws_route_table" "private_route_table_dev_data_engineering_az2" {
  vpc_id = aws_vpc.vpc_dev_data_engineering.id

  tags = {
    Name  = "private-route-table-dev-data-engineering-az2"
    owner = "dev-data-engineering"
  }
}

resource "aws_route" "private_route_dev_data_engineering_az2" {
  route_table_id         = aws_route_table.private_route_table_dev_data_engineering_az2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_dev_data_engineering_az2.id
}

resource "aws_route_table_association" "private_route_table_association_dev_data_engineering_az2" {
  subnet_id      = aws_subnet.private_subnet_dev_data_engineering_az2.id
  route_table_id = aws_route_table.private_route_table_dev_data_engineering_az2.id
}

# ============================================================
# ============================================================


/*
Não será utilizado para o projeto, mas deixarei o código comentado para referência futura.
(Decisão tomada após analisar novamente a estrutura do meu projeto e sua finalidade.)

# Criando um subnet group para o RDS, associando-o à sub-rede privada criada anteriormente, 
# garantindo que o banco de dado esteja isolado e protegido dentro da VPC.
resource "aws_db_subnet_group" "db_subnet_group_dev_data_engineering" {
  name        = "db-subnet-group-dev-data-engineering"
  description = "DB subnet group for RDS dev data engineering"

  subnet_ids = [
    aws_subnet.private_subnet_dev_data_engineering_az1.id,
    aws_subnet.private_subnet_dev_data_engineering_az2.id
  ]

  tags = {
    Name  = "db-subnet-group-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}
*/

# Criando um subnet group para o Redshift, associando-o à sub-rede privada criada anteriormente, 
# garantindo que o cluster de análise de dados esteja isolado e protegido dentro da VPC.
resource "aws_redshift_subnet_group" "redshift_subnet_group_dev_data_engineering" {
  name        = "redshift-subnet-group-dev-data-engineering"
  description = "Redshift subnet group for dev data engineering"

  subnet_ids = [
    aws_subnet.private_subnet_dev_data_engineering_az1.id,
    aws_subnet.private_subnet_dev_data_engineering_az2.id
  ]

  tags = {
    Name  = "redshift-subnet-group-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}

# Criando um endpoint de VPC para o S3, permitindo que os recursos dentro da VPC acessem o S3 sem precisar passar pela internet, 
# garantindo maior segurança e desempenho para as operações de leitura e escrita no bucket S3 criado anteriormente.
resource "aws_vpc_endpoint" "s3_endpoint_dev_data_engineering" {
  vpc_id       = aws_vpc.vpc_dev_data_engineering.id
  service_name = "com.amazonaws.us-east-1.s3"
  route_table_ids = [
    aws_route_table.private_route_table_dev_data_engineering_az1.id,
    aws_route_table.private_route_table_dev_data_engineering_az2.id
  ]

  tags = {
    Name  = "s3-endpoint-dev-data-engineering"
    owner = "dev-data-engineering"
  }
}