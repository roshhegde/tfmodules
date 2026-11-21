variable "name" {
  description = "Name of the HTTP API. Also prefixes the authorizer and access log group."
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function that handles requests."
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function."
  type        = string
}

variable "routes" {
  description = "Routes keyed by route key, for example { \"GET /items\" = { authorized = true }, \"GET /health\" = { authorized = false } }."
  type = map(object({
    authorized = bool
  }))
}

variable "jwt_issuer" {
  description = "JWT issuer URL, for example the cognito module's issuer_url. Null creates no authorizer."
  type        = string
  default     = null
  nullable    = true
}

variable "jwt_audience" {
  description = "Accepted JWT audiences, for example Cognito app client IDs."
  type        = list(string)
  default     = []
}

variable "cors_allowed_origins" {
  description = "Origins allowed to call the API from a browser. Empty disables CORS."
  type        = list(string)
  default     = []
}

variable "cors_allowed_methods" {
  description = "HTTP methods allowed for CORS."
  type        = list(string)
  default     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
}

variable "cors_allowed_headers" {
  description = "Request headers allowed for CORS."
  type        = list(string)
  default     = ["authorization", "content-type"]
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

variable "access_log_retention_days" {
  description = "Days to keep access logs. 0 turns access logging off."
  type        = number
  default     = 14
}

variable "tags" {
  description = "Additional tags to apply to the resources."
  type        = map(string)
  default     = {}
}
