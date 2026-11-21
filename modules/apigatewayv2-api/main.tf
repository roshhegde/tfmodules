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
