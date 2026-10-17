locals {
  cloudflare = {
    account_id = "5866a1959e70399a4020fd5a7657e1ca"
  }
}

resource "cloudflare_zone" "ssprangers" {
  name = "ssprangers.com"
  account = {
    id = local.cloudflare.account_id
  }
}

# ssprangers.com and www.ssprangers.com are Workers custom domains,
# managed by wrangler in static-site/wrangler.jsonc.

resource "cloudflare_dns_record" "production" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "production.ssprangers.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
  content = aws_api_gateway_domain_name.production-ssprangers-com.regional_domain_name
}

moved {
  from = cloudflare_record.production
  to   = cloudflare_dns_record.production
}

resource "cloudflare_dns_record" "master" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "master.ssprangers.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
  content = aws_api_gateway_domain_name.master-ssprangers-com.regional_domain_name
}

moved {
  from = cloudflare_record.master
  to   = cloudflare_dns_record.master
}

resource "cloudflare_dns_record" "dev" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "dev.ssprangers.com"
  type    = "CNAME"
  ttl     = 1
  content = aws_api_gateway_domain_name.dev-ssprangers-com.regional_domain_name
}

moved {
  from = cloudflare_record.dev
  to   = cloudflare_dns_record.dev
}

resource "cloudflare_dns_record" "facebook-domain-verification" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "ssprangers.com"
  type    = "TXT"
  ttl     = 1
  content = "facebook-domain-verification=jsmou9muxf1ful63ux8f80ppc20qfn"
}

moved {
  from = cloudflare_record.facebook-domain-verification
  to   = cloudflare_dns_record.facebook-domain-verification
}

resource "cloudflare_dns_record" "google-search-console-verification" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "ssprangers.com"
  type    = "TXT"
  ttl     = 1
  content = "google-site-verification=zQFfIq4Ga3UXepK3AoXpDvKwpKgBFQySpAkTM9N1_Zc"
}

moved {
  from = cloudflare_record.google-search-console-verification
  to   = cloudflare_dns_record.google-search-console-verification
}

resource "cloudflare_dns_record" "github-verify-domain" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "_github-challenge-hkssprangers.ssprangers.com"
  type    = "TXT"
  ttl     = 1
  content = "176ad4eb1c"
}

moved {
  from = cloudflare_record.github-verify-domain
  to   = cloudflare_dns_record.github-verify-domain
}
