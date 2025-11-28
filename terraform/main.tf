terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend para armazenar o state (descomente e configure se necessário)
  # backend "s3" {
  #   bucket = "seu-bucket-terraform-state"
  #   key    = "strapi/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region
}

