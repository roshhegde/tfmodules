output "api_id" {
  description = "ID of the API."
  value       = aws_apigatewayv2_api.this.id
}

output "api_endpoint" {
  description = "Base URL of the API."
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "execution_arn" {
  description = "Execution ARN of the API."
  value       = aws_apigatewayv2_api.this.execution_arn
}

output "authorizer_id" {
  description = "ID of the JWT authorizer, or null when none was created."
  value       = local.use_authorizer ? aws_apigatewayv2_authorizer.jwt[0].id : null
}
