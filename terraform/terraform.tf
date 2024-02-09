terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.36"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.24"
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

provider "aws" {
  alias = "cloudflare_r2"

  access_key = data.aws_ssm_parameter.r2-access-key-id.value
  secret_key = data.aws_ssm_parameter.r2-secret-access-key.value
  region     = "auto"

  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  # skip_get_ec2_platforms      = true
  endpoints {
    # https://developers.cloudflare.com/r2/platform/s3-compatibility/api/
    s3 = "https://${local.cloudflare.account_id}.r2.cloudflarestorage.com"
  }
}
