resource "cloudflare_r2_bucket" "terraform" {
  account_id = local.cloudflare.account_id
  name       = "hkssprangers-terraform"
  location   = "APAC"
}

# Private backups of the S3 buckets in s3.tf
resource "cloudflare_r2_bucket" "uploads" {
  account_id = local.cloudflare.account_id
  name       = "hkssprangers-uploads"
  location   = "APAC"
}

resource "cloudflare_r2_bucket" "dbbackup" {
  account_id = local.cloudflare.account_id
  name       = "hkssprangers-dbbackup"
  location   = "APAC"
}
