output "user_pool_id" {
  description = "ID of the user pool."
  value       = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  description = "ARN of the user pool."
  value       = aws_cognito_user_pool.this.arn
}

output "client_id" {
  description = "ID of the app client."
  value       = aws_cognito_user_pool_client.this.id
}

output "issuer_url" {
  description = "JWT issuer URL, for the apigateway module's jwt_issuer."
  value       = "https://${aws_cognito_user_pool.this.endpoint}"
}
