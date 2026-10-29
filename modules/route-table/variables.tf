variable "name" {
  description = "Name prefix applied to the route table."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the route table will be created."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to the route table."
  type        = map(string)
  default     = {}
}
