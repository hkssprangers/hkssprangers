resource "aws_api_gateway_domain_name" "ssprangers-com" {
  domain_name              = "ssprangers.com"
  regional_certificate_arn = aws_acm_certificate.ap-southeast-1-default.arn
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_apigatewayv2_domain_name" "dev-ssprangers-com" {
  domain_name = "dev.ssprangers.com"
  domain_name_configuration {
    certificate_arn = aws_acm_certificate.ap-southeast-1-default.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}
resource "aws_apigatewayv2_domain_name" "master-ssprangers-com" {
  domain_name = "master.ssprangers.com"
  domain_name_configuration {
    certificate_arn = aws_acm_certificate.ap-southeast-1-default.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}
resource "aws_api_gateway_domain_name" "production-ssprangers-com" {
  domain_name              = "production.ssprangers.com"
  regional_certificate_arn = aws_acm_certificate.ap-southeast-1-default.arn
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_api_gateway_domain_name" "www-ssprangers-com" {
  domain_name              = "www.ssprangers.com"
  regional_certificate_arn = aws_acm_certificate.ap-southeast-1-default.arn
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

data "aws_api_gateway_rest_api" "production-hkssprangers" {
  name = "production-hkssprangers"
}
data "aws_api_gateway_rest_api" "master-hkssprangers" {
  name = "master-hkssprangers"
}
data "aws_api_gateway_rest_api" "dev-hkssprangers" {
  name = "dev-hkssprangers"
}

resource "aws_api_gateway_base_path_mapping" "ssprangers-com" {
  api_id      = data.aws_api_gateway_rest_api.production-hkssprangers.id
  stage_name  = "production"
  domain_name = aws_api_gateway_domain_name.ssprangers-com.domain_name
}
resource "aws_api_gateway_base_path_mapping" "production-ssprangers-com" {
  api_id      = data.aws_api_gateway_rest_api.production-hkssprangers.id
  stage_name  = "production"
  domain_name = aws_api_gateway_domain_name.production-ssprangers-com.domain_name
}
resource "aws_api_gateway_base_path_mapping" "www-ssprangers-com" {
  api_id      = data.aws_api_gateway_rest_api.production-hkssprangers.id
  stage_name  = "production"
  domain_name = aws_api_gateway_domain_name.www-ssprangers-com.domain_name
}
