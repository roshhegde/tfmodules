variable "statement_id" {
  description = "Unique ID for the permission statement."
  type        = string
  default     = "AllowInvoke"
}

variable "function_name" {
  description = "Name of the Lambda function to grant access to."
  type        = string
}

variable "principal" {
  description = "Service principal allowed to invoke, for example apigateway.amazonaws.com."
  type        = string
}

variable "source_arn" {
  description = "ARN that limits which resource of the principal can invoke."
  type        = string
}
