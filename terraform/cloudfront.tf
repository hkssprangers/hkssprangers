resource "aws_cloudfront_distribution" "uploads" {
  origin {
    domain_name = module.s3_bucket_uploads.this_s3_bucket_bucket_regional_domain_name
    origin_id   = "s3_bucket_uploads"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["uploads.${cloudflare_zone.ssprangers.zone}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3_bucket_uploads"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 5
    max_ttl                = 31536000
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.default.certificate_arn
    ssl_support_method = "sni-only"
  }
}
