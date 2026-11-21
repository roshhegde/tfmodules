variable "log_groups" {
  description = "Log groups keyed by name, for example { \"/app/worker\" = { retention_in_days = 14 } }."
  type = map(object({
    retention_in_days = optional(number, 14)
  }))
  default = {}
}

variable "metric_alarms" {
  description = "Metric alarms keyed by alarm name."
  type = map(object({
    namespace           = string
    metric_name         = string
    threshold           = number
    description         = optional(string)
    dimensions          = optional(map(string), {})
    statistic           = optional(string, "Sum")
    period              = optional(number, 300)
    evaluation_periods  = optional(number, 1)
    comparison_operator = optional(string, "GreaterThanOrEqualToThreshold")
    treat_missing_data  = optional(string, "notBreaching")
    alarm_actions       = optional(list(string), [])
  }))
  default = {}
}

variable "tags" {
  description = "Additional tags to apply to the resources."
  type        = map(string)
  default     = {}
}
