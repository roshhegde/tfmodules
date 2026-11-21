# Everything for one API Gateway HTTP API in a single module: the API,
# an optional JWT authorizer, a Lambda proxy integration, routes, the
# $default stage with throttling and access logs, and the permission
# that lets API Gateway invoke the Lambda function.

locals {
  use_authorizer = var.jwt_issuer != null
}

resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  protocol_type = "HTTP"

  dynamic "cors_configuration" {
    for_each = length(var.cors_allowed_origins) == 0 ? [] : [1]
    content {
      allow_origins = var.cors_allowed_origins
      allow_methods = var.cors_allowed_methods
      allow_headers = var.cors_allowed_headers
      max_age       = 3600
    }
  }

  tags = merge(var.tags, {
    Name      = var.name
    ManagedBy = "Terraform"
  })
}

resource "aws_apigatewayv2_authorizer" "jwt" {
  count            = local.use_authorizer ? 1 : 0
  api_id           = aws_apigatewayv2_api.this.id
  name             = "${var.name}-jwt"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = var.jwt_issuer
    audience = var.jwt_audience
  }
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.lambda_invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "this" {
  for_each = var.routes

  api_id             = aws_apigatewayv2_api.this.id
  route_key          = each.key
  target             = "integrations/${aws_apigatewayv2_integration.lambda.id}"
  authorization_type = each.value.authorized ? "JWT" : "NONE"
  authorizer_id      = each.value.authorized ? aws_apigatewayv2_authorizer.jwt[0].id : null

  lifecycle {
    precondition {
      condition     = !each.value.authorized || local.use_authorizer
      error_message = "Route ${each.key} is authorized but jwt_issuer is not set."
    }
  }
}

resource "aws_cloudwatch_log_group" "access" {
  count             = var.access_log_retention_days > 0 ? 1 : 0
  name              = "/aws/apigateway/${var.name}"
  retention_in_days = var.access_log_retention_days

  tags = merge(var.tags, {
    ManagedBy = "Terraform"
  })
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = var.throttling_burst_limit
    throttling_rate_limit  = var.throttling_rate_limit
  }

  dynamic "access_log_settings" {
    for_each = var.access_log_retention_days > 0 ? [1] : []
    content {
      destination_arn = aws_cloudwatch_log_group.access[0].arn
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

resource "aws_lambda_permission" "invoke" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}
