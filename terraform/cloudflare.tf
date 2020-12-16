resource "cloudflare_zone" "ssprangers" {
  zone = "ssprangers.com"
}

resource "cloudflare_record" "aws-acm" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = tolist(aws_acm_certificate.default.domain_validation_options).0.resource_record_name
  value   = trimsuffix(tolist(aws_acm_certificate.default.domain_validation_options).0.resource_record_value, ".")
  type    = tolist(aws_acm_certificate.default.domain_validation_options).0.resource_record_type
}
