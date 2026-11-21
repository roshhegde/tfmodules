variable "name" {
  description = "Name of the DynamoDB table."
  type        = string
}

variable "billing_mode" {
  description = "PAY_PER_REQUEST (no idle cost) or PROVISIONED."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Partition key attribute name."
  type        = string
}

variable "hash_key_type" {
  description = "Partition key type: S, N or B."
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "Sort key attribute name, or null for a table without one."
  type        = string
  default     = null
  nullable    = true
}

variable "range_key_type" {
  description = "Sort key type: S, N or B."
  type        = string
  default     = "S"
}

variable "point_in_time_recovery" {
  description = "Enable point-in-time recovery (continuous backups)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to the resource."
  type        = map(string)
  default     = {}
}
