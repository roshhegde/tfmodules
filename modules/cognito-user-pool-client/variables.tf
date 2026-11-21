variable "name" {
  description = "Name of the app client."
  type        = string
}

variable "user_pool_id" {
  description = "ID of the user pool the client belongs to."
  type        = string
}

variable "generate_secret" {
  description = "Generate a client secret. Keep false for browser and CLI clients."
  type        = bool
  default     = false
}

variable "allow_password_auth" {
  description = "Enable USER_PASSWORD_AUTH, useful for CLI testing. Prefer SRP for real frontends."
  type        = bool
  default     = false
}

variable "token_validity_hours" {
  description = "Lifetime of access and ID tokens in hours."
  type        = number
  default     = 1
}

variable "refresh_token_validity_days" {
  description = "Lifetime of refresh tokens in days."
  type        = number
  default     = 30
}
