resource "random_id" "bucket-static-files-name" {
  byte_length = 8
}

resource "aws_s3_bucket" "static-files" {
  provider = aws.cloudflare_r2
  bucket   = "static-files-${random_id.bucket-static-files-name.hex}"
}
