resource "cloudflare_r2_bucket" "terraform" {
  account_id = local.cloudflare.account_id
  name       = "hkssprangers-terraform"
  location   = "APAC"
}
