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
  version = "~> 1.17"

  bucket = "hkssprangers-logs"
  acl    = "private"
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
