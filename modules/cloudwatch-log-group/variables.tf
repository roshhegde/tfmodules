variable "name" {
  description = "Name of the log group, for example /aws/lambda/my-function."
  type        = string
}

variable "retention_in_days" {
  description = "Days to keep log events. Short retention keeps costs low."
  type        = number
  default     = 14
}

variable "tags" {
  description = "Additional tags to apply to the resource."
  type        = map(string)
  default     = {}
}
