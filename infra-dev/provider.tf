terraform {

  backend "s3" {
    bucket  = "infra-dev-terraform-state"
    key     = "infra-dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.41.0"
    }
  }

}

provider "aws" {
  region = var.region
}