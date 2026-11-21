output "user_pool_id" {
  description = "ID of the user pool."
  value       = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  description = "ARN of the user pool."
  value       = aws_cognito_user_pool.this.arn
}

output "issuer_url" {
  description = "JWT issuer URL, for API Gateway JWT authorizers."
  value       = "https://${aws_cognito_user_pool.this.endpoint}"
}
