module "s3_bucket_terraform" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

  bucket = "hkssprangers-terraform"
  acl    = "private"

  versioning = {
    enabled = true
  }

  lifecycle_rule = [
    {
      id      = "terraform"
      enabled = true

      noncurrent_version_transition = [
        {
          days          = 60
          storage_class = "GLACIER"
        },
      ]

      noncurrent_version_expiration = {
        days = 180
      }
    }
  ]

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "s3_bucket_uploads" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

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
}

module "s3_bucket_logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

  bucket        = "hkssprangers-logs"
  acl           = "private"
  attach_policy = true
  policy        = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
          "Action": "s3:GetBucketAcl",
          "Effect": "Allow",
          "Resource": "arn:aws:s3:::hkssprangers-logs",
          "Principal": { "Service": "logs.${data.aws_region.current.name}.amazonaws.com" }
      },
      {
          "Action": "s3:PutObject" ,
          "Effect": "Allow",
          "Resource": "arn:aws:s3:::hkssprangers-logs/*",
          "Condition": { "StringEquals": { "s3:x-amz-acl": "bucket-owner-full-control" } },
          "Principal": { "Service": "logs.${data.aws_region.current.name}.amazonaws.com" }
      }
    ]
  }
  EOF
}

module "s3_bucket_dbbackup" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

  bucket = "hkssprangers-dbbackup"
  acl    = "private"

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

module "s3_bucket_static" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

  bucket = "hkssprangers-static"
  acl    = "private"

  lifecycle_rule = [
    {
      id      = "expireold"
      enabled = true

      transition = [
        {
          days          = 30
          storage_class = "GLACIER"
        },
      ]

      expiration = {
        days = 60
      }
    }
  ]
}

data "aws_iam_policy_document" "cloudfront_access_s3_static" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket_static.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cloudfront_static.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_bucket_static.s3_bucket_id
  policy = data.aws_iam_policy_document.cloudfront_access_s3_static.json
}
