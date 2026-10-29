variable "name" {
  description = "Name prefix applied to the subnet."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the subnet will be created."
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR range for the subnet."
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for the subnet. Defaults to the first available zone."
  type        = string
  default     = null
  nullable    = true
}

variable "map_public_ip_on_launch" {
  description = "Whether instances launched in this subnet receive a public IPv4 address."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to the subnet."
  type        = map(string)
  default     = {}
}
