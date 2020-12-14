module "s3_bucket_terraform" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 1.17"

  bucket = "hkssprangers-terraform"
  acl    = "private"

  versioning = {
    enabled = true
  }
}
