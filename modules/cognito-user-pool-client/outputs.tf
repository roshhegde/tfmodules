output "client_id" {
  description = "ID of the app client."
  value       = aws_cognito_user_pool_client.this.id
}
