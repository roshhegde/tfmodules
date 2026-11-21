output "statement_id" {
  description = "ID of the permission statement."
  value       = aws_lambda_permission.this.statement_id
}
