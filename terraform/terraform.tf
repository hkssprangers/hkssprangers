terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.13"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.14"
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

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = data.aws_ssm_parameter.cloudflare_api_token.value
}