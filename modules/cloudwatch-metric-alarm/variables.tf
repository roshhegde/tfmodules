variable "alarm_name" {
  description = "Name of the alarm."
  type        = string
}

variable "alarm_description" {
  description = "Description of the alarm."
  type        = string
  default     = null
  nullable    = true
}

variable "namespace" {
  description = "Metric namespace, for example AWS/Lambda."
  type        = string
}

variable "metric_name" {
  description = "Metric name, for example Errors."
  type        = string
}

variable "dimensions" {
  description = "Metric dimensions, for example { FunctionName = \"my-fn\" }."
  type        = map(string)
  default     = {}
}

variable "statistic" {
  description = "Statistic to apply: Sum, Average, Minimum, Maximum or SampleCount."
  type        = string
  default     = "Sum"
}

variable "period" {
  description = "Length of each evaluation period in seconds."
  type        = number
  default     = 300
}

variable "evaluation_periods" {
  description = "Number of periods compared with the threshold."
  type        = number
  default     = 1
}

variable "threshold" {
  description = "Value the statistic is compared with."
  type        = number
}

variable "comparison_operator" {
  description = "How the statistic is compared with the threshold."
  type        = string
  default     = "GreaterThanOrEqualToThreshold"
}

variable "treat_missing_data" {
  description = "How to treat missing data points: missing, ignore, breaching or notBreaching."
  type        = string
  default     = "notBreaching"
}

variable "alarm_actions" {
  description = "ARNs to notify when the alarm fires, for example an SNS topic."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to the resource."
  type        = map(string)
  default     = {}
}
