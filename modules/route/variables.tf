variable "route_table_id" {
  description = "ID of the route table receiving this route."
  type        = string
}

variable "destination_cidr_block" {
  description = "IPv4 CIDR destination for the route."
  type        = string
}

variable "gateway_id" {
  description = "ID of an internet gateway used as the route target. Set this or nat_gateway_id, not both."
  type        = string
  default     = null
  nullable    = true
}

variable "nat_gateway_id" {
  description = "ID of a NAT gateway used as the route target. Set this or gateway_id, not both."
  type        = string
  default     = null
  nullable    = true
}
