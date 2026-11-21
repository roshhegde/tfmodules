resource "aws_apigatewayv2_stage" "this" {
  api_id      = var.api_id
  name        = var.name
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = var.throttling_burst_limit
    throttling_rate_limit  = var.throttling_rate_limit
  }

  dynamic "access_log_settings" {
    for_each = var.access_log_group_arn == null ? [] : [1]
    content {
      destination_arn = var.access_log_group_arn
      format = jsonencode({
        requestId = "$context.requestId"
        ip        = "$context.identity.sourceIp"
        route     = "$context.routeKey"
        status    = "$context.status"
        latencyMs = "$context.integrationLatency"
        user      = "$context.authorizer.claims.sub"
      })
    }
  }

  tags = merge(var.tags, {
    ManagedBy = "Terraform"
  })
}
