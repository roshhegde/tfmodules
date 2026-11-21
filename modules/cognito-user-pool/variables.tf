variable "name" {
  description = "Name of the user pool."
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

variable "tags" {
  description = "Additional tags to apply to the resource."
  type        = map(string)
  default     = {}
}
