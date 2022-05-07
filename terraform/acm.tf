resource "aws_acm_certificate" "default" {
  provider                  = aws.us-east-1
  domain_name               = cloudflare_zone.ssprangers.zone
  subject_alternative_names = ["*.${cloudflare_zone.ssprangers.zone}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "default" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.default.arn
  validation_record_fqdns = [cloudflare_record.aws-acm.hostname]
}

resource "aws_acm_certificate" "ap-southeast-1-default" {
  domain_name               = cloudflare_zone.ssprangers.zone
  subject_alternative_names = ["*.${cloudflare_zone.ssprangers.zone}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
