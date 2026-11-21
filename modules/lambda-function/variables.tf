variable "function_name" {
  description = "Name of the Lambda function."
  type        = string
}

variable "role_arn" {
  description = "ARN of the execution role, for example from modules/iam-role."
  type        = string
}

variable "filename" {
  description = "Path to the deployment package zip."
  type        = string
}

variable "source_code_hash" {
  description = "Base64 SHA256 of the package, so code changes trigger an update."
  type        = string
}

variable "handler" {
  description = "Function entry point, for example handler.lambda_handler."
  type        = string
}

variable "runtime" {
  description = "Lambda runtime identifier."
  type        = string
  default     = "python3.12"
}

variable "architecture" {
  description = "arm64 (Graviton, cheaper per ms) or x86_64."
  type        = string
  default     = "arm64"
}

variable "memory_size" {
  description = "Memory in MB."
  type        = number
  default     = 256
}

variable "timeout" {
  description = "Timeout in seconds."
  type        = number
  default     = 10
}

variable "environment_variables" {
  description = "Environment variables passed to the function."
  type        = map(string)
  default     = {}
}

variable "tracing_mode" {
  description = "X-Ray tracing mode: Active or PassThrough."
  type        = string
  default     = "Active"
}

variable "tags" {
  description = "Additional tags to apply to the resource."
  type        = map(string)
  default     = {}
}
