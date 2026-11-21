variable "name" {
  description = "Name prefix for the user pool (<name>-users) and app client (<name>-client)."
  type        = string
}

variable "password_min_length" {
  description = "Minimum password length."
  type        = number
  default     = 12
}

variable "password_require_symbols" {
  description = "Require at least one symbol in passwords."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Block deleting the pool while it has users. Leave off for demo stacks you destroy."
  type        = bool
  default     = false
}

variable "generate_client_secret" {
  description = "Generate an app client secret. Keep false for browser and CLI clients."
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

variable "tags" {
  description = "Additional tags to apply to the resources."
  type        = map(string)
  default     = {}
}
