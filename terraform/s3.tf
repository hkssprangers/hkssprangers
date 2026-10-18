module "s3_bucket_uploads" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.17.0"

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

  cors_rule = [
    {
      allowed_methods = ["PUT"]
      allowed_origins = ["*"]
      allowed_headers = ["*"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    }
  ]

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

module "s3_bucket_dbbackup" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.17.0"

  bucket = "hkssprangers-dbbackup"
  acl    = "private"

  # Keep the existing behavior; s3-bucket module 5.x defaults to all_storage_classes_128K
  transition_default_minimum_object_size = "varies_by_storage_class"
  lifecycle_rule = [
    {
      id      = "dbbackup"
      enabled = true

      transition = [
        {
          days          = 60
          storage_class = "GLACIER"
        },
      ]

      expiration = {
        days = 180
      }
    }
  ]

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
