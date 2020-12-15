module "s3_bucket_terraform" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 1.17"

  bucket = "hkssprangers-terraform"
  acl    = "private"

  versioning = {
    enabled = true
  }
}

module "s3_bucket_uploads" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 1.17"

  bucket        = "hkssprangers-uploads"
  acl           = "public-read"
  attach_policy = true
  policy        = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "PublicReadGetObject",
              "Effect": "Allow",
              "Principal": "*",
              "Action": "s3:GetObject",
              "Resource": "arn:aws:s3:::hkssprangers-uploads/*"
          }
      ]
  }
  EOF

  website = {
    index_document = "index.html"
  }
}
