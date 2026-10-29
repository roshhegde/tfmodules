variable "name" {
  description = "Name prefix applied to the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR range for the VPC."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to the VPC."
  type        = map(string)
  default     = {}
}
