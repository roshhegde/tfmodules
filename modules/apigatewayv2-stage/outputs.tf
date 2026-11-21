output "stage_id" {
  description = "ID of the stage."
  value       = aws_apigatewayv2_stage.this.id
}

output "invoke_url" {
  description = "URL that invokes the stage."
  value       = aws_apigatewayv2_stage.this.invoke_url
}
