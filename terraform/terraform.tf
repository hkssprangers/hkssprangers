terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.14"
    }
  }
  
  backend "s3" {
    bucket         = "hkssprangers-terraform"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform"
  }
}

provider "aws" {}
data "aws_region" "current" {}

provider "cloudflare" {
  api_key = data.aws_ssm_parameter.cloudflare_api_key.value
}