resource "random_id" "bucket-static-files-name" {
  byte_length = 8
}

resource "cloudflare_r2_bucket" "static-files" {
  account_id = local.cloudflare.account_id
  name       = "static-files-${random_id.bucket-static-files-name.hex}"
  location   = "APAC"
}
