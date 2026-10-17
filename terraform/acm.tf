resource "aws_acm_certificate" "ap-southeast-1-default" {
  domain_name               = cloudflare_zone.ssprangers.name
  subject_alternative_names = ["*.${cloudflare_zone.ssprangers.name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "ap-southeast-1-default" {
  certificate_arn         = aws_acm_certificate.ap-southeast-1-default.arn
  validation_record_fqdns = [for record in cloudflare_dns_record.acm-validation : record.name]
}

resource "cloudflare_dns_record" "acm-validation" {
  for_each = {
    for dvo in aws_acm_certificate.ap-southeast-1-default.domain_validation_options : dvo.resource_record_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }...
  }

  zone_id = cloudflare_zone.ssprangers.id
  name    = trimsuffix(each.value[0].name, ".")
  type    = each.value[0].type
  proxied = false
  ttl     = 1
  content = trimsuffix(each.value[0].record, ".")
}

moved {
  from = cloudflare_record.acm-validation
  to   = cloudflare_dns_record.acm-validation
}
