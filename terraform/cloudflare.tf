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

resource "cloudflare_dns_record" "facebook-domain-verification" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "ssprangers.com"
  type    = "TXT"
  ttl     = 1
  content = "facebook-domain-verification=jsmou9muxf1ful63ux8f80ppc20qfn"
}

resource "cloudflare_dns_record" "google-search-console-verification" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "ssprangers.com"
  type    = "TXT"
  ttl     = 1
  content = "google-site-verification=zQFfIq4Ga3UXepK3AoXpDvKwpKgBFQySpAkTM9N1_Zc"
}

resource "cloudflare_dns_record" "github-verify-domain" {
  zone_id = cloudflare_zone.ssprangers.id
  name    = "_github-challenge-hkssprangers.ssprangers.com"
  type    = "TXT"
  ttl     = 1
  content = "176ad4eb1c"
}
