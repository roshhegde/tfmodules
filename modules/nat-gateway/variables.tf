variable "name" {
  description = "Name prefix applied to the NAT gateway and its Elastic IP."
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet where the NAT gateway is placed. It must route to an internet gateway."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to the NAT gateway and Elastic IP."
  type        = map(string)
  default     = {}
}
