variable "api_id" {
  description = "ID of the HTTP API."
  type        = string
}

variable "name" {
  description = "Stage name. $default serves the API at its base URL."
  type        = string
  default     = "$default"
}

variable "throttling_rate_limit" {
  description = "Steady-state requests per second. Caps cost if the URL leaks."
  type        = number
  default     = 10
}

variable "throttling_burst_limit" {
  description = "Maximum burst of requests."
  type        = number
  default     = 20
}

variable "access_log_group_arn" {
  description = "ARN of a CloudWatch log group for access logs, or null to turn them off."
  type        = string
  default     = null
  nullable    = true
}

variable "tags" {
  description = "Additional tags to apply to the resource."
  type        = map(string)
  default     = {}
}
