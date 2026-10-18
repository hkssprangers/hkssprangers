terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.44"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.28"
    }
  }

  # State lives in the R2 bucket in r2.tf.
  backend "s3" {
    bucket    = "hkssprangers-terraform"
    key       = "terraform.tfstate"
    region    = "auto"
    endpoints = { s3 = "https://${local.cloudflare.account_id}.r2.cloudflarestorage.com" }

    # Set via TF_VAR_r2_access_key_id and TF_VAR_r2_secret_access_key in the gitignored mise.local.toml.
    access_key = var.r2_access_key_id
    secret_key = var.r2_secret_access_key

    use_lockfile = true

    # R2 isn't AWS: skip the AWS-specific checks
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

variable "r2_access_key_id" {
  type = string
}

variable "r2_secret_access_key" {
  type = string
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
