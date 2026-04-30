resource "aws_api_gateway_rest_api" "api" { name = "secure-api" }

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "process"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled = true
  origin {
    domain_name = "${aws_api_gateway_rest_api.api.id}.execute-api.us-east-1.amazonaws.com"
    origin_id   = "api-origin"
  }
  default_cache_behavior {
    target_origin_id       = "api-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "POST", "PUT", "DELETE"]
    cached_methods         = ["GET"]
  }
  viewer_certificate { 
    cloudfront_default_certificate = true 
  }
  web_acl_id = var.waf_arn
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}