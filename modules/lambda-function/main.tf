resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  role             = var.role_arn
  runtime          = var.runtime
  handler          = var.handler
  filename         = var.filename
  source_code_hash = var.source_code_hash
  memory_size      = var.memory_size
  timeout          = var.timeout
  architectures    = [var.architecture]

  dynamic "environment" {
    for_each = length(var.environment_variables) == 0 ? [] : [1]
    content {
      variables = var.environment_variables
    }
  }

  tracing_config {
    mode = var.tracing_mode
  }

  tags = merge(var.tags, {
    Name      = var.function_name
    ManagedBy = "Terraform"
  })
}
