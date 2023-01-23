locals {
  cloudflare = {
    account_id = "5866a1959e70399a4020fd5a7657e1ca"
  }
}

resource "cloudflare_zone" "ssprangers" {
  account_id = local.cloudflare.account_id
  zone       = "ssprangers.com"
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
  value   = aws_api_gateway_domain_name.production-ssprangers-com.regional_domain_name
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "master" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "master"
  value   = aws_api_gateway_domain_name.master-ssprangers-com.regional_domain_name
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "dev" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "dev"
  value   = aws_api_gateway_domain_name.dev-ssprangers-com.regional_domain_name
  type    = "CNAME"
}

resource "cloudflare_record" "www" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "www"
  value   = "ssprangers.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "facebook-domain-verification" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "ssprangers.com"
  value   = "facebook-domain-verification=jsmou9muxf1ful63ux8f80ppc20qfn"
  type    = "TXT"
}

resource "cloudflare_record" "google-search-console-verification" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "ssprangers.com"
  value   = "google-site-verification=zQFfIq4Ga3UXepK3AoXpDvKwpKgBFQySpAkTM9N1_Zc"
  type    = "TXT"
}

resource "cloudflare_record" "github-verify-domain" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "_github-challenge-hkssprangers"
  value   = "176ad4eb1c"
  type    = "TXT"
}
