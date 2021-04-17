resource "cloudflare_zone" "ssprangers" {
  zone = "ssprangers.com"
}

resource "cloudflare_record" "aws-acm" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = tolist(aws_acm_certificate.default.domain_validation_options).0.resource_record_name
  value   = trimsuffix(tolist(aws_acm_certificate.default.domain_validation_options).0.resource_record_value, ".")
  type    = tolist(aws_acm_certificate.default.domain_validation_options).0.resource_record_type
}

resource "cloudflare_record" "ssprangers" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "ssprangers.com"
  value   = "production.ssprangers.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "production" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "production"
  value   = "d-h25rgwffz8.execute-api.ap-southeast-1.amazonaws.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "master" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "master"
  value   = "d-8njywa7so9.execute-api.ap-southeast-1.amazonaws.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "dev" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "dev"
  value   = "d-ip6lixd84a.execute-api.ap-southeast-1.amazonaws.com"
  type    = "CNAME"
}

resource "cloudflare_record" "facebook-domain-verification" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "ssprangers.com"
  value   = "facebook-domain-verification=jsmou9muxf1ful63ux8f80ppc20qfn"
  type    = "TXT"
}
