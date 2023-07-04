resource "aws_acm_certificate" "ap-southeast-1-default" {
  domain_name               = cloudflare_zone.ssprangers.zone
  subject_alternative_names = ["*.${cloudflare_zone.ssprangers.zone}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "ap-southeast-1-default" {
  certificate_arn         = aws_acm_certificate.ap-southeast-1-default.arn
  validation_record_fqdns = [for record in cloudflare_record.acm-validation : record.hostname]
}

resource "cloudflare_record" "acm-validation" {
  for_each = {
    for dvo in aws_acm_certificate.ap-southeast-1-default.domain_validation_options : dvo.resource_record_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }...
  }

  zone_id = cloudflare_zone.ssprangers.id
  name    = each.value[0].name
  value   = each.value[0].record
  type    = each.value[0].type
  proxied = false
}
