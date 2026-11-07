variable "name" {
  description = "Name of the IAM role."
  type        = string
}

variable "assume_role_policy" {
  description = "JSON trust policy that controls who can assume the role."
  type        = string
}

variable "managed_policy_arns" {
  description = "ARNs of managed policies to attach to the role."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to the role."
  type        = map(string)
  default     = {}
}
