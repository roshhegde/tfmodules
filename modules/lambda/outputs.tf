output "function_name" {
  description = "Name of the function."
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "ARN of the function."
  value       = aws_lambda_function.this.arn
}

output "invoke_arn" {
  description = "ARN used by API Gateway integrations to invoke the function."
  value       = aws_lambda_function.this.invoke_arn
}

output "log_group_arn" {
  description = "ARN of the function's log group. Grant logs:PutLogEvents on it in the execution role."
  value       = aws_cloudwatch_log_group.this.arn
}
