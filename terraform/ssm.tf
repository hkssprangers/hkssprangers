data "aws_ssm_parameter" "cloudflare_api_token" {
  name = "cloudflare_api_token"
}

data "aws_ssm_parameter" "r2-access-key-id" {
  name = "r2-access-key-id"
}

data "aws_ssm_parameter" "r2-secret-access-key" {
  name = "r2-secret-access-key"
}

