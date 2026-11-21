resource "aws_apigatewayv2_authorizer" "this" {
  api_id           = var.api_id
  name             = var.name
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = var.issuer
    audience = var.audience
  }
}
