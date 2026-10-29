variable "route_table_id" {
  description = "ID of the route table receiving this route."
  type        = string
}

variable "destination_cidr_block" {
  description = "IPv4 CIDR destination for the route."
  type        = string
}

variable "gateway_id" {
  description = "ID of the gateway used as the route target."
  type        = string
}
