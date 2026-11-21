variable "api_id" {
  description = "ID of the HTTP API."
  type        = string
}

variable "name" {
  description = "Name of the authorizer."
  type        = string
  default     = "jwt"
}

variable "issuer" {
  description = "JWT issuer URL, for example a Cognito user pool's issuer_url."
  type        = string
}

variable "audience" {
  description = "Accepted audiences, for example Cognito app client IDs."
  type        = list(string)
}
