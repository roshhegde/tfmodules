resource "aws_apigatewayv2_route" "this" {
  api_id             = var.api_id
  route_key          = var.route_key
  target             = "integrations/${var.integration_id}"
  authorization_type = var.authorizer_id == null ? "NONE" : "JWT"
  authorizer_id      = var.authorizer_id
}
