resource "aws_acm_certificate" "ap-southeast-1-default" {
  domain_name               = cloudflare_zone.ssprangers.zone
  subject_alternative_names = ["*.${cloudflare_zone.ssprangers.zone}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
