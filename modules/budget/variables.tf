variable "name" {
  description = "Name of the budget."
  type        = string
}

variable "limit_amount_usd" {
  description = "Monthly cost limit in USD, as a string, for example \"5\"."
  type        = string
}

variable "alert_emails" {
  description = "Email addresses that receive budget alerts."
  type        = list(string)
}

variable "actual_thresholds_percent" {
  description = "Alert when actual spend passes these percentages of the limit."
  type        = list(number)
  default     = [50, 100]
}

variable "forecasted_thresholds_percent" {
  description = "Alert when forecast spend passes these percentages of the limit."
  type        = list(number)
  default     = [100]
}

variable "tags" {
  description = "Additional tags to apply to the resource."
  type        = map(string)
  default     = {}
}
