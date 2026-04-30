resource "aws_wafv2_web_acl" "waf" {
  name  = "main-waf"
  scope = "CLOUDFRONT"

  # Error Fixed: Nested block moved to its own line
  default_action {
    allow {}
  }

  rule {
    name     = "AWSCommon"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "waf"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-main"
    sampled_requests_enabled   = true
  }
}
