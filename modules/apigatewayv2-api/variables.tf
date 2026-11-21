variable "name" {
  description = "Name of the HTTP API."
  type        = string
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

variable "tags" {
  description = "Additional tags to apply to the resource."
  type        = map(string)
  default     = {}
}
