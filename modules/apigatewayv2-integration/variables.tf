variable "api_id" {
  description = "ID of the HTTP API."
  type        = string
}

variable "integration_uri" {
  description = "Invoke ARN of the Lambda function."
  type        = string
}

variable "payload_format_version" {
  description = "Lambda event payload format: 2.0 or 1.0."
  type        = string
  default     = "2.0"
}
